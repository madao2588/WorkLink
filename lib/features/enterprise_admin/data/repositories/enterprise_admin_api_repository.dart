import 'package:my_first_app/app/shared/network/api_client.dart';
import 'package:my_first_app/features/enterprise_admin/domain/models/enterprise_admin_models.dart';
import 'package:my_first_app/features/enterprise_admin/domain/repositories/enterprise_admin_repository.dart';

class EnterpriseAdminApiRepository implements EnterpriseAdminRepository {
  EnterpriseAdminApiRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<EnterpriseAdminOrganizationData> fetchOrganizationData() async {
    final dynamic response = await _apiClient.get('/org/admin/overview');
    final List<EmployeeRecord> employees = (response['employees'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(_mapEmployee)
        .toList();
    final List<DepartmentRecord> departments = (response['departments'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(_mapDepartment)
        .toList();
    final List<PositionRecord> positions = (response['positions'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(_mapPosition)
        .toList();
    final List<AccountRecord> accounts = (response['accounts'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(_mapAccount)
        .toList();

    return EnterpriseAdminOrganizationData(
      employees: employees,
      departments: departments,
      positions: positions,
      accounts: accounts,
    );
  }

  @override
  Future<List<ChangeRequestRecord>> fetchChangeRequests() async {
    final dynamic response = await _apiClient.get('/org/change-requests');
    return (response['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(_mapChangeRequest)
        .toList();
  }

  @override
  Future<ChangeRequestDetailRecord> fetchChangeRequestDetail(String requestId) async {
    final dynamic response = await _apiClient.get('/org/change-requests/$requestId');
    return _mapChangeRequestDetail(response as Map<String, dynamic>);
  }

  @override
  Future<ChangeRequestDetailRecord> approveChangeRequest(String requestId) async {
    final dynamic response = await _apiClient.patch(
      '/org/change-requests/$requestId/approve',
      body: const <String, dynamic>{},
    );
    return _mapChangeRequestDetail(response as Map<String, dynamic>);
  }

  @override
  Future<ChangeRequestDetailRecord> rejectChangeRequest(String requestId) async {
    final dynamic response = await _apiClient.patch(
      '/org/change-requests/$requestId/reject',
      body: const <String, dynamic>{},
    );
    return _mapChangeRequestDetail(response as Map<String, dynamic>);
  }

  @override
  Future<EmployeeRecord> updateEmployee({
    required String employeeId,
    required String departmentId,
    required String position,
    required String email,
    required String phone,
  }) async {
    final dynamic response = await _apiClient.patch(
      '/org/admin/employees/$employeeId',
      body: <String, dynamic>{
        'departmentId': departmentId,
        'position': position,
        'email': email,
        'mobile': phone,
      },
    );
    return _mapEmployee(response as Map<String, dynamic>);
  }

  @override
  Future<DepartmentRecord> updateDepartment({
    required String departmentId,
    required String name,
    required String leader,
    required String description,
  }) async {
    final dynamic response = await _apiClient.patch(
      '/org/admin/departments/$departmentId',
      body: <String, dynamic>{
        'name': name,
        'leader': leader,
        'description': description,
      },
    );
    return _mapDepartment(response as Map<String, dynamic>);
  }

  @override
  Future<PositionRecord> updatePosition({
    required String positionId,
    required String title,
    required String level,
    required int openQuota,
  }) async {
    final dynamic response = await _apiClient.patch(
      '/org/admin/positions/$positionId',
      body: <String, dynamic>{
        'title': title,
        'level': level,
        'openQuota': openQuota,
      },
    );
    return _mapPosition(response as Map<String, dynamic>);
  }

  @override
  Future<ChangeRequestReceipt> createChangeRequest({
    required String entityType,
    required String entityId,
    required String entityName,
    required String changeType,
    required String note,
    required Map<String, String> snapshot,
  }) async {
    final dynamic response = await _apiClient.post(
      '/org/change-requests',
      body: <String, dynamic>{
        'entityType': entityType,
        'entityId': entityId,
        'entityName': entityName,
        'changeType': changeType,
        'note': note,
        'snapshot': snapshot,
      },
    );

    return ChangeRequestReceipt(
      id: response['id'] as String? ?? '',
      requestNo: response['requestNo'] as String? ?? '',
      entityType: response['entityType'] as String? ?? entityType,
      entityId: response['entityId'] as String? ?? entityId,
      entityName: response['entityName'] as String? ?? entityName,
      changeType: response['changeType'] as String? ?? changeType,
      note: response['note'] as String? ?? note,
      status: response['status'] as String? ?? 'DRAFTED',
      submittedAt: DateTime.tryParse(response['submittedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  @override
  Future<AccountRecord> updateAccount({
    required String userId,
    required AccountRole role,
    required bool enabled,
  }) async {
    final dynamic response = await _apiClient.patch(
      '/org/admin/accounts/$userId',
      body: <String, dynamic>{
        'role': _roleKey(role),
        'enabled': enabled,
      },
    );
    return _mapAccount(response as Map<String, dynamic>);
  }

  EmployeeRecord _mapEmployee(Map<String, dynamic> json) {
    final String positionName = (json['position'] as String? ?? '').trim();
    final String employeeNo = (json['employeeNo'] as String? ?? '').trim();
    final String positionId = (json['positionId'] as String? ?? '').trim();

    return EmployeeRecord(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      employeeNo: employeeNo.isEmpty ? 'N/A' : employeeNo,
      departmentId: json['departmentId'] as String? ?? '',
      departmentName: json['department'] as String? ?? '',
      positionId: positionId.isEmpty ? _positionIdFor(positionName) : positionId,
      positionName: positionName.isEmpty ? 'Unassigned' : positionName,
      phone: (json['mobile'] as String?)?.trim().isNotEmpty == true
          ? json['mobile'] as String
          : json['mobileMasked'] as String? ?? '',
      email: json['email'] as String? ?? '',
      status: json['status'] as String? ?? 'Active',
    );
  }

  DepartmentRecord _mapDepartment(Map<String, dynamic> json) {
    return DepartmentRecord(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      leader: json['leader'] as String? ?? '',
      memberCount: json['memberCount'] as int? ?? 0,
      description: json['description'] as String? ?? '',
    );
  }

  PositionRecord _mapPosition(Map<String, dynamic> json) {
    return PositionRecord(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      level: json['level'] as String? ?? '',
      departmentName: json['departmentName'] as String? ?? '',
      headcount: json['headcount'] as int? ?? 0,
      openQuota: json['openQuota'] as int? ?? 0,
    );
  }

  AccountRecord _mapAccount(Map<String, dynamic> json) {
    return AccountRecord(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      loginId: json['loginId'] as String? ?? '',
      role: _mapAccountRole(json['role'] as String? ?? ''),
      enabled: json['enabled'] as bool? ?? false,
      boundUserIds: (json['boundUserIds'] as List<dynamic>? ?? <dynamic>[])
          .whereType<String>()
          .toList(),
      boundNames: (json['boundNames'] as List<dynamic>? ?? <dynamic>[])
          .whereType<String>()
          .toList(),
      boundDepartmentIds: (json['boundDepartmentIds'] as List<dynamic>? ?? <dynamic>[])
          .whereType<String>()
          .toList(),
    );
  }

  ChangeRequestRecord _mapChangeRequest(Map<String, dynamic> json) {
    return ChangeRequestRecord(
      id: json['id'] as String? ?? '',
      requestNo: json['requestNo'] as String? ?? '',
      entityType: json['entityType'] as String? ?? '',
      entityId: json['entityId'] as String? ?? '',
      entityName: json['entityName'] as String? ?? '',
      changeType: json['changeType'] as String? ?? '',
      note: json['note'] as String? ?? '',
      status: json['status'] as String? ?? 'DRAFTED',
      requesterName: json['requesterName'] as String? ?? '',
      submittedAt:
          DateTime.tryParse(json['submittedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  ChangeRequestDetailRecord _mapChangeRequestDetail(Map<String, dynamic> json) {
    return ChangeRequestDetailRecord(
      id: json['id'] as String? ?? '',
      requestNo: json['requestNo'] as String? ?? '',
      entityType: json['entityType'] as String? ?? '',
      entityId: json['entityId'] as String? ?? '',
      entityName: json['entityName'] as String? ?? '',
      changeType: json['changeType'] as String? ?? '',
      note: json['note'] as String? ?? '',
      status: json['status'] as String? ?? 'DRAFTED',
      requesterName: json['requesterName'] as String? ?? '',
      submittedAt:
          DateTime.tryParse(json['submittedAt'] as String? ?? '') ?? DateTime.now(),
      snapshot: (json['snapshot'] as Map<String, dynamic>? ?? <String, dynamic>{})
          .map(
            (Object? key, Object? value) => MapEntry(
              '$key',
              value?.toString() ?? '',
            ),
          ),
    );
  }

  String _positionIdFor(String positionName) {
    if (positionName.isEmpty) {
      return 'position-unassigned';
    }

    final String normalized = positionName.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]+'),
      '-',
    );
    return normalized.isEmpty ? 'position-custom' : 'position-$normalized';
  }

  AccountRole _mapAccountRole(String value) {
    switch (value) {
      case 'superAdmin':
        return AccountRole.superAdmin;
      case 'hrManager':
        return AccountRole.hrManager;
      case 'departmentManager':
        return AccountRole.departmentManager;
      case 'viewer':
      default:
        return AccountRole.viewer;
    }
  }

  String _roleKey(AccountRole role) {
    switch (role) {
      case AccountRole.superAdmin:
        return 'superAdmin';
      case AccountRole.hrManager:
        return 'hrManager';
      case AccountRole.departmentManager:
        return 'departmentManager';
      case AccountRole.viewer:
        return 'viewer';
    }
  }
}
