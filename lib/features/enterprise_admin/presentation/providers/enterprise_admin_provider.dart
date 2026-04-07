import 'dart:async';

import 'package:flutter/material.dart';

import 'package:my_first_app/app/shared/models/user_model.dart';
import 'package:my_first_app/app/shared/network/api_client.dart';
import 'package:my_first_app/features/enterprise_admin/application/enterprise_excel_export_service.dart';
import 'package:my_first_app/features/enterprise_admin/domain/models/enterprise_admin_models.dart';
import 'package:my_first_app/features/enterprise_admin/domain/repositories/enterprise_admin_repository.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

class EnterpriseAdminProvider with ChangeNotifier {
  EnterpriseAdminProvider({
    required EnterpriseExcelExportService exportService,
    required EnterpriseAdminRepository repository,
  }) : _exportService = exportService,
       _repository = repository {
    _restoreFallbackAdminData();
  }

  final EnterpriseExcelExportService _exportService;
  final EnterpriseAdminRepository _repository;

  final List<EmployeeRecord> _employees = <EmployeeRecord>[];
  final List<DepartmentRecord> _departments = <DepartmentRecord>[];
  final List<PositionRecord> _positions = <PositionRecord>[];
  final List<AccountRecord> _accounts = <AccountRecord>[];
  final List<ChangeRequestRecord> _changeRequests = <ChangeRequestRecord>[];

  UserModel? _sessionUser;
  AccountRole _currentRole = AccountRole.viewer;
  Set<AdminPermission> _sessionPermissions = const <AdminPermission>{};
  bool _currentAccountEnabled = true;
  String _employeeKeyword = '';
  String _departmentKeyword = '';
  String _positionKeyword = '';
  String _accountKeyword = '';
  bool _isExporting = false;
  bool _isOrganizationLoading = false;
  bool _isChangeRequestsLoading = false;
  bool _usingLiveOrganizationData = false;
  String? _organizationErrorMessage;
  String? _changeRequestsErrorMessage;
  DateTime? _organizationLastSyncedAt;
  String? _lastSyncedUserKey;

  static const Map<AccountRole, Set<AdminPermission>> _permissionsByRole =
      <AccountRole, Set<AdminPermission>>{
        AccountRole.superAdmin: <AdminPermission>{
          AdminPermission.manageEmployees,
          AdminPermission.manageDepartments,
          AdminPermission.managePositions,
          AdminPermission.manageAccounts,
          AdminPermission.exportData,
          AdminPermission.viewDashboard,
        },
        AccountRole.hrManager: <AdminPermission>{
          AdminPermission.manageEmployees,
          AdminPermission.manageDepartments,
          AdminPermission.managePositions,
          AdminPermission.exportData,
          AdminPermission.viewDashboard,
        },
        AccountRole.departmentManager: <AdminPermission>{
          AdminPermission.manageEmployees,
          AdminPermission.viewDashboard,
        },
        AccountRole.viewer: <AdminPermission>{AdminPermission.viewDashboard},
      };

  static const Map<String, AccountRole> _fallbackDepartmentRoles =
      <String, AccountRole>{
        'dept-hr': AccountRole.hrManager,
        'dept-rd': AccountRole.departmentManager,
      };

  List<EmployeeRecord> get employees => List<EmployeeRecord>.unmodifiable(
    _employees.where((EmployeeRecord item) {
      final String keyword = _employeeKeyword.trim().toLowerCase();
      if (keyword.isEmpty) {
        return true;
      }
      return item.name.toLowerCase().contains(keyword) ||
          item.employeeNo.toLowerCase().contains(keyword) ||
          item.departmentName.toLowerCase().contains(keyword) ||
          item.positionName.toLowerCase().contains(keyword);
    }),
  );

  List<DepartmentRecord> get departments => List<DepartmentRecord>.unmodifiable(
    _departments.where((DepartmentRecord item) {
      final String keyword = _departmentKeyword.trim().toLowerCase();
      if (keyword.isEmpty) {
        return true;
      }
      return item.name.toLowerCase().contains(keyword) ||
          item.leader.toLowerCase().contains(keyword);
    }),
  );

  List<PositionRecord> get positions => List<PositionRecord>.unmodifiable(
    _positions.where((PositionRecord item) {
      final String keyword = _positionKeyword.trim().toLowerCase();
      if (keyword.isEmpty) {
        return true;
      }
      return item.title.toLowerCase().contains(keyword) ||
          item.departmentName.toLowerCase().contains(keyword) ||
          item.level.toLowerCase().contains(keyword);
    }),
  );

  List<AccountRecord> get accounts => List<AccountRecord>.unmodifiable(
    _accounts.where((AccountRecord item) {
      final String keyword = _accountKeyword.trim().toLowerCase();
      if (keyword.isEmpty) {
        return true;
      }
      return item.name.toLowerCase().contains(keyword) ||
          item.loginId.toLowerCase().contains(keyword);
    }),
  );
  List<ChangeRequestRecord> get changeRequests =>
      List<ChangeRequestRecord>.unmodifiable(_changeRequests);

  AccountRole get currentRole => _currentRole;
  bool get isExporting => _isExporting;
  bool get isOrganizationLoading => _isOrganizationLoading;
  bool get isChangeRequestsLoading => _isChangeRequestsLoading;
  bool get usingLiveOrganizationData => _usingLiveOrganizationData;
  String? get organizationErrorMessage => _organizationErrorMessage;
  String? get changeRequestsErrorMessage => _changeRequestsErrorMessage;
  DateTime? get organizationLastSyncedAt => _organizationLastSyncedAt;
  Set<AdminPermission> get currentPermissions {
    if (!_currentAccountEnabled) {
      return const <AdminPermission>{};
    }
    if (_sessionPermissions.isNotEmpty) {
      return _sessionPermissions;
    }
    return _permissionsByRole[_currentRole] ?? const <AdminPermission>{};
  }

  bool hasPermission(AdminPermission permission) {
    return currentPermissions.contains(permission);
  }

  String permissionDeniedMessage(
    AdminPermission permission,
    AppLocalizations l10n,
  ) {
    switch (permission) {
      case AdminPermission.manageEmployees:
        return l10n.enterpriseAdminPermissionEmployees;
      case AdminPermission.manageDepartments:
        return l10n.enterpriseAdminPermissionDepartments;
      case AdminPermission.managePositions:
        return l10n.enterpriseAdminPermissionPositions;
      case AdminPermission.manageAccounts:
        return l10n.enterpriseAdminPermissionAccounts;
      case AdminPermission.exportData:
        return l10n.enterpriseAdminPermissionExport;
      case AdminPermission.viewDashboard:
        return l10n.enterpriseAdminPermissionDashboard;
    }
  }

  void syncSession(UserModel? user) {
    final String? nextUserKey = user == null ? null : _userSyncKey(user);
    final bool shouldReload =
        nextUserKey != null && nextUserKey != _lastSyncedUserKey;

    _sessionUser = user;
    _currentRole = _resolveRoleForUser(user);
    _sessionPermissions = _resolvePermissionsForUser(user);
    _currentAccountEnabled = true;

    if (user == null) {
      _lastSyncedUserKey = null;
      _isOrganizationLoading = false;
      _usingLiveOrganizationData = false;
      _organizationErrorMessage = null;
      _changeRequestsErrorMessage = null;
      _organizationLastSyncedAt = null;
      _currentAccountEnabled = false;
      _restoreFallbackAdminData();
      notifyListeners();
      return;
    }

    if (shouldReload) {
      _lastSyncedUserKey = nextUserKey;
    }

    notifyListeners();

    if (shouldReload) {
      unawaited(reloadOrganizationData());
      unawaited(reloadChangeRequests());
    }
  }

  void setEmployeeKeyword(String value) {
    _employeeKeyword = value;
    notifyListeners();
  }

  void setDepartmentKeyword(String value) {
    _departmentKeyword = value;
    notifyListeners();
  }

  void setPositionKeyword(String value) {
    _positionKeyword = value;
    notifyListeners();
  }

  void setAccountKeyword(String value) {
    _accountKeyword = value;
    notifyListeners();
  }

  void saveEmployee(EmployeeRecord record) {
    final int index = _employees.indexWhere(
      (EmployeeRecord item) => item.id == record.id,
    );
    if (index >= 0) {
      _employees[index] = record;
    } else {
      _employees.insert(0, record);
    }
    _recalculateDepartmentCounts();
    notifyListeners();
  }

  void deleteEmployee(String id) {
    _employees.removeWhere((EmployeeRecord item) => item.id == id);
    _recalculateDepartmentCounts();
    notifyListeners();
  }

  void saveDepartment(DepartmentRecord record) {
    final int index = _departments.indexWhere(
      (DepartmentRecord item) => item.id == record.id,
    );
    if (index >= 0) {
      _departments[index] = record;
    } else {
      _departments.insert(0, record);
    }
    notifyListeners();
  }

  void deleteDepartment(String id) {
    final DepartmentRecord? target = _departments.cast<DepartmentRecord?>()
        .firstWhere(
          (DepartmentRecord? item) => item?.id == id,
          orElse: () => null,
        );
    if (target == null) {
      return;
    }
    _departments.removeWhere((DepartmentRecord item) => item.id == id);
    _employees.removeWhere((EmployeeRecord item) => item.departmentId == id);
    _positions.removeWhere(
      (PositionRecord item) => item.departmentName == target.name,
    );
    _recalculateDepartmentCounts();
    notifyListeners();
  }

  void savePosition(PositionRecord record) {
    final int index = _positions.indexWhere(
      (PositionRecord item) => item.id == record.id,
    );
    if (index >= 0) {
      _positions[index] = record;
    } else {
      _positions.insert(0, record);
    }
    notifyListeners();
  }

  void deletePosition(String id) {
    _positions.removeWhere((PositionRecord item) => item.id == id);
    notifyListeners();
  }

  void saveAccount(AccountRecord record) {
    final int index = _accounts.indexWhere(
      (AccountRecord item) => item.id == record.id,
    );
    if (index >= 0) {
      _accounts[index] = record;
    } else {
      _accounts.insert(0, record);
    }
    notifyListeners();
  }

  void deleteAccount(String id) {
    _accounts.removeWhere((AccountRecord item) => item.id == id);
    notifyListeners();
  }

  Future<void> reloadOrganizationData() async {
    if (_sessionUser == null) {
      return;
    }

    _isOrganizationLoading = true;
    _organizationErrorMessage = null;
    notifyListeners();

    try {
      final EnterpriseAdminOrganizationData data =
          await _repository.fetchOrganizationData();
      _employees
        ..clear()
        ..addAll(data.employees);
      _departments
        ..clear()
        ..addAll(data.departments);
      _positions
        ..clear()
        ..addAll(data.positions);
      _accounts
        ..clear()
        ..addAll(data.accounts);
      _recalculateDepartmentCounts();
      _usingLiveOrganizationData = true;
      _organizationLastSyncedAt = DateTime.now();
    } on ApiException catch (error) {
      _organizationErrorMessage = error.message;
      _usingLiveOrganizationData = false;
      _organizationLastSyncedAt = null;
      _restoreFallbackAdminData();
    } catch (_) {
      _organizationErrorMessage = 'Failed to load organization data';
      _usingLiveOrganizationData = false;
      _organizationLastSyncedAt = null;
      _restoreFallbackAdminData();
    } finally {
      _isOrganizationLoading = false;
      notifyListeners();
    }
  }

  Future<void> reloadChangeRequests() async {
    if (_sessionUser == null) {
      return;
    }

    _isChangeRequestsLoading = true;
    _changeRequestsErrorMessage = null;
    notifyListeners();

    try {
      final List<ChangeRequestRecord> items =
          await _repository.fetchChangeRequests();
      _changeRequests
        ..clear()
        ..addAll(items);
    } on ApiException catch (error) {
      _changeRequestsErrorMessage = error.message;
    } catch (_) {
      _changeRequestsErrorMessage = 'Failed to load change requests';
    } finally {
      _isChangeRequestsLoading = false;
      notifyListeners();
    }
  }

  Future<ChangeRequestDetailRecord> fetchChangeRequestDetail(
    String requestId,
  ) {
    return _repository.fetchChangeRequestDetail(requestId);
  }

  Future<ChangeRequestDetailRecord> approveChangeRequest(String requestId) async {
    final ChangeRequestDetailRecord detail =
        await _repository.approveChangeRequest(requestId);
    await Future.wait<void>(<Future<void>>[
      reloadChangeRequests(),
      reloadOrganizationData(),
    ]);
    return detail;
  }

  Future<ChangeRequestDetailRecord> rejectChangeRequest(String requestId) async {
    final ChangeRequestDetailRecord detail =
        await _repository.rejectChangeRequest(requestId);
    await reloadChangeRequests();
    return detail;
  }

  Future<String?> exportEmployees(AppLocalizations l10n) async {
    return _export(
      fileName: 'employees.xlsx',
      permission: AdminPermission.exportData,
      headers: <String>[
        l10n.enterpriseAdminExportHeaderEmployeeNo,
        l10n.enterpriseAdminExportHeaderName,
        l10n.enterpriseAdminExportHeaderDepartment,
        l10n.enterpriseAdminExportHeaderPosition,
        l10n.enterpriseAdminExportHeaderPhone,
        l10n.enterpriseAdminExportHeaderEmail,
        l10n.enterpriseAdminExportHeaderStatus,
      ],
      rows: _employees
          .map(
            (EmployeeRecord item) => <Object?>[
              item.employeeNo,
              item.name,
              item.departmentName,
              item.positionName,
              item.phone,
              item.email,
              item.status,
            ],
          )
          .toList(),
    );
  }

  Future<String?> exportDepartments(AppLocalizations l10n) async {
    return _export(
      fileName: 'departments.xlsx',
      permission: AdminPermission.exportData,
      headers: <String>[
        l10n.enterpriseAdminExportHeaderDepartment,
        l10n.enterpriseAdminExportHeaderLeader,
        l10n.enterpriseAdminExportHeaderCount,
        l10n.enterpriseAdminExportHeaderDescription,
      ],
      rows: _departments
          .map(
            (DepartmentRecord item) => <Object?>[
              item.name,
              item.leader,
              item.memberCount,
              item.description,
            ],
          )
          .toList(),
    );
  }

  Future<String?> exportPositions(AppLocalizations l10n) async {
    return _export(
      fileName: 'positions.xlsx',
      permission: AdminPermission.exportData,
      headers: <String>[
        l10n.enterpriseAdminExportHeaderPosition,
        l10n.enterpriseAdminExportHeaderLevel,
        l10n.enterpriseAdminExportHeaderDepartmentOwned,
        l10n.enterpriseAdminExportHeaderHeadcount,
        l10n.enterpriseAdminExportHeaderVacancy,
      ],
      rows: _positions
          .map(
            (PositionRecord item) => <Object?>[
              item.title,
              item.level,
              item.departmentName,
              item.headcount,
              item.openQuota,
            ],
          )
          .toList(),
    );
  }

  Future<ChangeRequestReceipt> submitChangeRequest({
    required String entityType,
    required String entityId,
    required String entityName,
    required String changeType,
    required String note,
    required Map<String, String> snapshot,
  }) {
    return _repository.createChangeRequest(
      entityType: entityType,
      entityId: entityId,
      entityName: entityName,
      changeType: changeType,
      note: note,
      snapshot: snapshot,
    ).then((ChangeRequestReceipt receipt) {
      unawaited(reloadChangeRequests());
      return receipt;
    });
  }

  Future<EmployeeRecord> updateEmployeeRecord({
    required String employeeId,
    required String departmentId,
    required String position,
    required String email,
    required String phone,
  }) async {
    final EmployeeRecord updated = await _repository.updateEmployee(
      employeeId: employeeId,
      departmentId: departmentId,
      position: position,
      email: email,
      phone: phone,
    );
    final int index = _employees.indexWhere(
      (EmployeeRecord item) => item.id == updated.id,
    );
    if (index >= 0) {
      _employees[index] = updated;
    } else {
      _employees.insert(0, updated);
    }
    _recalculateDepartmentCounts();
    _recalculatePositionHeadcounts();
    unawaited(reloadChangeRequests());
    notifyListeners();
    return updated;
  }

  Future<DepartmentRecord> updateDepartmentRecord({
    required String departmentId,
    required String name,
    required String leader,
    required String description,
  }) async {
    final int existingIndex = _departments.indexWhere(
      (DepartmentRecord item) => item.id == departmentId,
    );
    final DepartmentRecord? existing = existingIndex >= 0
        ? _departments[existingIndex]
        : null;
    final DepartmentRecord updated = await _repository.updateDepartment(
      departmentId: departmentId,
      name: name,
      leader: leader,
      description: description,
    );

    if (existingIndex >= 0) {
      _departments[existingIndex] = updated;
    } else {
      _departments.insert(0, updated);
    }

    if (existing != null && existing.name != updated.name) {
      for (int index = 0; index < _employees.length; index++) {
        final EmployeeRecord employee = _employees[index];
        if (employee.departmentId != updated.id) {
          continue;
        }
        _employees[index] = employee.copyWith(departmentName: updated.name);
      }
      for (int index = 0; index < _positions.length; index++) {
        final PositionRecord position = _positions[index];
        if (position.departmentName != existing.name) {
          continue;
        }
        _positions[index] = position.copyWith(departmentName: updated.name);
      }
    }

    unawaited(reloadChangeRequests());
    notifyListeners();
    return updated;
  }

  Future<AccountRecord> updateAccountRecord({
    required String userId,
    required AccountRole role,
    required bool enabled,
  }) async {
    final AccountRecord updated = await _repository.updateAccount(
      userId: userId,
      role: role,
      enabled: enabled,
    );
    final int index = _accounts.indexWhere(
      (AccountRecord item) => item.id == updated.id,
    );
    if (index >= 0) {
      _accounts[index] = updated;
    } else {
      _accounts.insert(0, updated);
    }

    final String? sessionUserId = _normalize(_sessionUser?.id);
    if (sessionUserId != null &&
        updated.boundUserIds.any((String value) => _normalize(value) == sessionUserId)) {
      _currentAccountEnabled = enabled;
      _currentRole = enabled ? updated.role : AccountRole.viewer;
      _sessionPermissions = enabled
          ? (_permissionsByRole[updated.role] ?? const <AdminPermission>{})
          : const <AdminPermission>{};
    }

    unawaited(reloadChangeRequests());
    notifyListeners();
    return updated;
  }

  Future<PositionRecord> updatePositionRecord({
    required String positionId,
    required String title,
    required String level,
    required int openQuota,
  }) async {
    final int existingIndex = _positions.indexWhere(
      (PositionRecord item) => item.id == positionId,
    );
    final PositionRecord? existing = existingIndex >= 0
        ? _positions[existingIndex]
        : null;
    final PositionRecord updated = await _repository.updatePosition(
      positionId: positionId,
      title: title,
      level: level,
      openQuota: openQuota,
    );

    if (existingIndex >= 0) {
      _positions[existingIndex] = updated;
    } else {
      _positions.insert(0, updated);
    }

    if (existing != null && existing.title != updated.title) {
      for (int index = 0; index < _employees.length; index++) {
        final EmployeeRecord employee = _employees[index];
        final bool matchesPositionId = employee.positionId == updated.id;
        final bool matchesLegacyLabel =
            employee.departmentName == updated.departmentName &&
            employee.positionName == existing.title;
        if (!matchesPositionId && !matchesLegacyLabel) {
          continue;
        }
        _employees[index] = employee.copyWith(
          positionId: updated.id,
          positionName: updated.title,
        );
      }
    }

    unawaited(reloadChangeRequests());
    notifyListeners();
    return updated;
  }

  List<({String label, int value, Color color})> get departmentShare {
    final List<Color> palette = <Color>[
      const Color(0xFF1456F0),
      const Color(0xFF16A085),
      const Color(0xFFF79009),
      const Color(0xFFE25563),
      const Color(0xFF7A5AF8),
    ];

    return _departments.asMap().entries.map((entry) {
      return (
        label: entry.value.name,
        value: entry.value.memberCount,
        color: palette[entry.key % palette.length],
      );
    }).toList();
  }

  List<({String label, double value})> hiringTrend(AppLocalizations l10n) {
    return <({String label, double value})>[
      (label: l10n.enterpriseAdminMonthJan, value: 4),
      (label: l10n.enterpriseAdminMonthFeb, value: 7),
      (label: l10n.enterpriseAdminMonthMar, value: 6),
      (label: l10n.enterpriseAdminMonthApr, value: 8),
      (label: l10n.enterpriseAdminMonthMay, value: 10),
      (label: l10n.enterpriseAdminMonthJun, value: 9),
    ];
  }

  int get totalEmployees => _employees.length;
  int get totalDepartments => _departments.length;
  int get totalPositions => _positions.length;
  int get totalVacancies => _positions.fold<int>(
    0,
    (int sum, PositionRecord item) => sum + item.openQuota,
  );
  int get enabledAccounts =>
      _accounts.where((AccountRecord item) => item.enabled).length;
  int get totalChangeRequests => _changeRequests.length;
  int get appliedChangeRequests =>
      _changeRequests.where((ChangeRequestRecord item) => item.status == 'APPLIED').length;
  int get draftedChangeRequests =>
      _changeRequests.where((ChangeRequestRecord item) => item.status == 'DRAFTED').length;
  String currentRoleLabel(AppLocalizations l10n) =>
      _roleLabel(_currentRole, l10n);
  String sessionUserName(AppLocalizations l10n) =>
      _sessionUser?.name ?? l10n.enterpriseAdminSessionUserFallback;

  Future<String?> _export({
    required String fileName,
    required AdminPermission permission,
    required List<String> headers,
    required List<List<Object?>> rows,
  }) async {
    if (!hasPermission(permission)) {
      return null;
    }
    _isExporting = true;
    notifyListeners();
    try {
      return await _exportService.export(
        fileName: fileName,
        headers: headers,
        rows: rows,
      );
    } finally {
      _isExporting = false;
      notifyListeners();
    }
  }

  void _recalculateDepartmentCounts() {
    for (int index = 0; index < _departments.length; index++) {
      final DepartmentRecord item = _departments[index];
      final int count = _employees
          .where((EmployeeRecord employee) => employee.departmentId == item.id)
          .length;
      _departments[index] = item.copyWith(memberCount: count);
    }
  }

  void _recalculatePositionHeadcounts() {
    final Map<String, int> headcountByKey = <String, int>{};
    for (final EmployeeRecord employee in _employees) {
      final String key = '${employee.departmentName}::${employee.positionName}';
      headcountByKey[key] = (headcountByKey[key] ?? 0) + 1;
    }

    final List<PositionRecord> rebuilt = <PositionRecord>[];
    final Set<String> seenKeys = <String>{};
    for (final PositionRecord item in _positions) {
      final String key = '${item.departmentName}::${item.title}';
      rebuilt.add(item.copyWith(headcount: headcountByKey[key] ?? 0));
      seenKeys.add(key);
    }

    for (final EmployeeRecord employee in _employees) {
      final String key = '${employee.departmentName}::${employee.positionName}';
      if (seenKeys.contains(key)) {
        continue;
      }
      rebuilt.add(
        PositionRecord(
          id: employee.positionId,
          title: employee.positionName,
          level: 'P2',
          departmentName: employee.departmentName,
          headcount: headcountByKey[key] ?? 0,
          openQuota: 0,
        ),
      );
      seenKeys.add(key);
    }

    _positions
      ..clear()
      ..addAll(rebuilt);
  }

  AccountRole _resolveRoleForUser(UserModel? user) {
    if (user == null) {
      return AccountRole.viewer;
    }

    final AccountRole? sessionRole = _mapRole(user.role);
    if (sessionRole != null) {
      return sessionRole;
    }

    final AccountRecord? boundAccount = _findBoundAccount(user);
    if (boundAccount != null && boundAccount.enabled) {
      return boundAccount.role;
    }

    final String? departmentId = _normalize(user.departmentId);
    if (departmentId != null) {
      return _fallbackDepartmentRoles[departmentId] ?? AccountRole.viewer;
    }

    return AccountRole.viewer;
  }

  Set<AdminPermission> _resolvePermissionsForUser(UserModel? user) {
    if (user == null) {
      return const <AdminPermission>{};
    }

    final Set<AdminPermission> fromSession = user.permissions
        .map(_mapPermission)
        .whereType<AdminPermission>()
        .toSet();
    if (fromSession.isNotEmpty) {
      return fromSession;
    }

    return _permissionsByRole[_resolveRoleForUser(user)] ??
        const <AdminPermission>{};
  }

  AccountRecord? _findBoundAccount(UserModel user) {
    final String? loginId = _normalize(user.loginId);
    final String? userId = _normalize(user.id);
    final String? name = _normalize(user.name);
    final String? departmentId = _normalize(user.departmentId);

    for (final AccountRecord account in _accounts) {
      if (_normalize(account.loginId) == loginId) {
        return account;
      }
      if (userId != null &&
          account.boundUserIds.any((String value) => _normalize(value) == userId)) {
        return account;
      }
      if (name != null &&
          account.boundNames.any((String value) => _normalize(value) == name)) {
        return account;
      }
      if (departmentId != null &&
          account.boundDepartmentIds.any(
            (String value) => _normalize(value) == departmentId,
          )) {
        return account;
      }
    }

    return null;
  }

  String? _normalize(String? value) {
    final String normalized = value?.trim().toLowerCase() ?? '';
    if (normalized.isEmpty) {
      return null;
    }
    return normalized;
  }

  String _roleLabel(AccountRole role, AppLocalizations l10n) {
    switch (role) {
      case AccountRole.superAdmin:
        return l10n.enterpriseAdminRoleSuperAdmin;
      case AccountRole.hrManager:
        return l10n.enterpriseAdminRoleHrManager;
      case AccountRole.departmentManager:
        return l10n.enterpriseAdminRoleDepartmentManager;
      case AccountRole.viewer:
        return l10n.enterpriseAdminRoleViewer;
    }
  }

  AccountRole? _mapRole(String? value) {
    switch (value) {
      case 'superAdmin':
        return AccountRole.superAdmin;
      case 'hrManager':
        return AccountRole.hrManager;
      case 'departmentManager':
        return AccountRole.departmentManager;
      case 'viewer':
        return AccountRole.viewer;
      default:
        return null;
    }
  }

  AdminPermission? _mapPermission(String value) {
    switch (value) {
      case 'manageEmployees':
        return AdminPermission.manageEmployees;
      case 'manageDepartments':
        return AdminPermission.manageDepartments;
      case 'managePositions':
        return AdminPermission.managePositions;
      case 'manageAccounts':
        return AdminPermission.manageAccounts;
      case 'exportData':
        return AdminPermission.exportData;
      case 'viewDashboard':
        return AdminPermission.viewDashboard;
      default:
        return null;
    }
  }

  String _userSyncKey(UserModel user) {
    return '${user.id}:${user.loginId ?? ''}:${user.departmentId ?? ''}';
  }

  void _restoreFallbackAdminData() {
    _employees
      ..clear()
      ..addAll(_fallbackEmployees);
    _departments
      ..clear()
      ..addAll(_fallbackDepartments);
    _positions
      ..clear()
      ..addAll(_seedPositions);
    _accounts
      ..clear()
      ..addAll(_seedAccounts);
    _changeRequests
      ..clear()
      ..addAll(_seedChangeRequests);
    _recalculateDepartmentCounts();
  }

  List<DepartmentRecord> get _fallbackDepartments => const <DepartmentRecord>[
    DepartmentRecord(
      id: 'dep-1',
      name: '产品研发中心',
      leader: '林嘉禾',
      memberCount: 0,
      description: '负责产品规划、研发交付和技术平台建设',
    ),
    DepartmentRecord(
      id: 'dep-2',
      name: '人力资源部',
      leader: '周可欣',
      memberCount: 0,
      description: '负责招聘、培训、绩效与组织发展',
    ),
    DepartmentRecord(
      id: 'dep-3',
      name: '市场运营部',
      leader: '赵远',
      memberCount: 0,
      description: '负责市场增长、品牌传播和客户运营',
    ),
  ];

  List<EmployeeRecord> get _fallbackEmployees => const <EmployeeRecord>[
    EmployeeRecord(
      id: 'emp-1',
      name: '陈语',
      employeeNo: 'WK1001',
      departmentId: 'dep-1',
      departmentName: '产品研发中心',
      positionId: 'pos-1',
      positionName: 'Flutter 开发工程师',
      phone: '13800001234',
      email: 'chenyu@worklink.com',
      status: '在职',
    ),
    EmployeeRecord(
      id: 'emp-2',
      name: '周可欣',
      employeeNo: 'WK1002',
      departmentId: 'dep-2',
      departmentName: '人力资源部',
      positionId: 'pos-2',
      positionName: 'HRBP',
      phone: '13800004567',
      email: 'zhoukx@worklink.com',
      status: '在职',
    ),
    EmployeeRecord(
      id: 'emp-3',
      name: '赵远',
      employeeNo: 'WK1003',
      departmentId: 'dep-3',
      departmentName: '市场运营部',
      positionId: 'pos-3',
      positionName: '运营专员',
      phone: '13800007890',
      email: 'zhaoyuan@worklink.com',
      status: '试用',
    ),
    EmployeeRecord(
      id: 'emp-4',
      name: '林嘉禾',
      employeeNo: 'WK1004',
      departmentId: 'dep-1',
      departmentName: '产品研发中心',
      positionId: 'pos-1',
      positionName: 'Flutter 开发工程师',
      phone: '13800002222',
      email: 'linjh@worklink.com',
      status: '在职',
    ),
  ];

  List<PositionRecord> get _seedPositions => const <PositionRecord>[
    PositionRecord(
      id: 'pos-1',
      title: 'Flutter 开发工程师',
      level: 'P5',
      departmentName: '产品研发中心',
      headcount: 6,
      openQuota: 2,
    ),
    PositionRecord(
      id: 'pos-2',
      title: 'HRBP',
      level: 'P4',
      departmentName: '人力资源部',
      headcount: 4,
      openQuota: 1,
    ),
    PositionRecord(
      id: 'pos-3',
      title: '运营专员',
      level: 'P3',
      departmentName: '市场运营部',
      headcount: 8,
      openQuota: 3,
    ),
  ];

  List<ChangeRequestRecord> get _seedChangeRequests => <ChangeRequestRecord>[
    ChangeRequestRecord(
      id: 'cr-demo-1',
      requestNo: 'CR-DEMO-001',
      entityType: 'employee',
      entityId: 'emp-1',
      entityName: '陈语',
      changeType: 'profile_fix',
      note: '同步手机号与邮箱字段',
      status: 'APPLIED',
      requesterName: 'madao',
      submittedAt: DateTime(2026, 4, 7, 9, 30),
    ),
    ChangeRequestRecord(
      id: 'cr-demo-2',
      requestNo: 'CR-DEMO-002',
      entityType: 'department',
      entityId: 'dep-1',
      entityName: '产品研发中心',
      changeType: 'org_adjustment',
      note: '更新部门负责人显示',
      status: 'DRAFTED',
      requesterName: 'zhangsan',
      submittedAt: DateTime(2026, 4, 7, 11, 10),
    ),
  ];

  List<AccountRecord> get _seedAccounts => const <AccountRecord>[
    AccountRecord(
      id: 'acc-1',
      name: '系统管理员',
      loginId: 'admin',
      role: AccountRole.superAdmin,
      enabled: true,
      boundNames: <String>['admin'],
    ),
    AccountRecord(
      id: 'acc-2',
      name: 'HR 管理员',
      loginId: 'wangwu',
      role: AccountRole.hrManager,
      enabled: true,
      boundUserIds: <String>['u_2'],
      boundNames: <String>['王五'],
      boundDepartmentIds: <String>['dept-hr'],
    ),
    AccountRecord(
      id: 'acc-3',
      name: '研发主管',
      loginId: 'zhangsan',
      role: AccountRole.departmentManager,
      enabled: true,
      boundUserIds: <String>['u_me'],
      boundNames: <String>['张三'],
      boundDepartmentIds: <String>['dept-rd'],
    ),
    AccountRecord(
      id: 'acc-4',
      name: '数据查看员',
      loginId: 'viewer',
      role: AccountRole.viewer,
      enabled: false,
    ),
  ];
}
