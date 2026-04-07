import 'package:flutter_test/flutter_test.dart';

import 'package:my_first_app/app/shared/models/user_model.dart';
import 'package:my_first_app/features/enterprise_admin/application/enterprise_excel_export_service.dart';
import 'package:my_first_app/features/enterprise_admin/domain/models/enterprise_admin_models.dart';
import 'package:my_first_app/features/enterprise_admin/domain/repositories/enterprise_admin_repository.dart';
import 'package:my_first_app/features/enterprise_admin/presentation/providers/enterprise_admin_provider.dart';

void main() {
  EnterpriseAdminProvider buildProvider({
    EnterpriseAdminRepository? repository,
  }) {
    return EnterpriseAdminProvider(
      exportService: EnterpriseExcelExportService(),
      repository: repository ?? FakeEnterpriseAdminRepository(),
    );
  }

  test('resolves department manager from explicit demo login binding', () {
    final EnterpriseAdminProvider provider = buildProvider();

    provider.syncSession(
      UserModel(
        id: 'u_me',
        name: '张三',
        avatar: 'ZS',
        department: '研发部',
        loginId: 'zhangsan',
        departmentId: 'dept-rd',
      ),
    );

    expect(provider.currentRole, AccountRole.departmentManager);
    expect(provider.hasPermission(AdminPermission.manageEmployees), isTrue);
    expect(provider.hasPermission(AdminPermission.manageAccounts), isFalse);
  });

  test('resolves hr manager from explicit hr binding', () {
    final EnterpriseAdminProvider provider = buildProvider();

    provider.syncSession(
      UserModel(
        id: 'u_2',
        name: '王五',
        avatar: 'WW',
        department: '人事部',
        loginId: 'wangwu',
        departmentId: 'dept-hr',
      ),
    );

    expect(provider.currentRole, AccountRole.hrManager);
    expect(provider.hasPermission(AdminPermission.manageDepartments), isTrue);
    expect(provider.hasPermission(AdminPermission.manageAccounts), isFalse);
  });

  test('falls back to viewer when no explicit binding exists', () {
    final EnterpriseAdminProvider provider = buildProvider();

    provider.syncSession(
      UserModel(
        id: 'u_guest',
        name: '访客',
        avatar: 'FK',
        department: '外部协作',
        loginId: 'guest',
        departmentId: 'dept-ext',
      ),
    );

    expect(provider.currentRole, AccountRole.viewer);
    expect(provider.hasPermission(AdminPermission.viewDashboard), isTrue);
    expect(provider.hasPermission(AdminPermission.exportData), isFalse);
  });

  test('loads employees and departments from repository after session sync', () async {
    final EnterpriseAdminProvider provider = buildProvider(
      repository: FakeEnterpriseAdminRepository(
        data: const EnterpriseAdminOrganizationData(
          employees: <EmployeeRecord>[
            EmployeeRecord(
              id: 'u-live',
              name: '李青',
              employeeNo: 'WL2001',
              departmentId: 'dept-live',
              departmentName: '平台工程部',
              positionId: 'pos-live',
              positionName: '平台工程师',
              phone: '138****1234',
              email: 'liqing@worklink.local',
              status: 'Active',
            ),
          ],
          departments: <DepartmentRecord>[
            DepartmentRecord(
              id: 'dept-live',
              name: '平台工程部',
              leader: '',
              memberCount: 0,
              description: '',
            ),
          ],
          positions: <PositionRecord>[
            PositionRecord(
              id: 'pos-live',
              title: '平台工程师',
              level: 'P5',
              departmentName: '平台工程部',
              headcount: 1,
              openQuota: 0,
            ),
          ],
          accounts: <AccountRecord>[
            AccountRecord(
              id: 'account-live',
              name: '张三',
              loginId: 'zhangsan',
              role: AccountRole.departmentManager,
              enabled: true,
              boundUserIds: <String>['u_me'],
              boundNames: <String>['张三'],
              boundDepartmentIds: <String>['dept-rd'],
            ),
          ],
        ),
      ),
    );

    provider.syncSession(
      UserModel(
        id: 'u_me',
        name: '张三',
        avatar: 'ZS',
        department: '研发部',
        loginId: 'zhangsan',
        departmentId: 'dept-rd',
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(provider.usingLiveOrganizationData, isTrue);
    expect(provider.totalEmployees, 1);
    expect(provider.totalDepartments, 1);
    expect(provider.totalPositions, 1);
    expect(provider.enabledAccounts, 1);
    expect(provider.employees.first.name, '李青');
    expect(provider.departments.first.name, '平台工程部');
  });

  test('keeps fallback organization data when repository fails', () async {
    final EnterpriseAdminProvider provider = buildProvider(
      repository: FakeEnterpriseAdminRepository(shouldThrow: true),
    );

    provider.syncSession(
      UserModel(
        id: 'u_me',
        name: '张三',
        avatar: 'ZS',
        department: '研发部',
        loginId: 'zhangsan',
        departmentId: 'dept-rd',
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(provider.usingLiveOrganizationData, isFalse);
    expect(provider.organizationErrorMessage, isNotNull);
    expect(provider.totalEmployees, greaterThan(0));
    expect(provider.totalDepartments, greaterThan(0));
  });

  test('prefers role and permissions from session payload', () {
    final EnterpriseAdminProvider provider = buildProvider();

    provider.syncSession(
      UserModel(
        id: 'u_guest',
        name: 'viewer',
        avatar: 'VW',
        department: 'external',
        loginId: 'guest',
        departmentId: 'dept-ext',
        role: 'hrManager',
        permissions: const <String>[
          'manageEmployees',
          'manageDepartments',
          'managePositions',
          'exportData',
          'viewDashboard',
        ],
      ),
    );

    expect(provider.currentRole, AccountRole.hrManager);
    expect(provider.hasPermission(AdminPermission.manageDepartments), isTrue);
    expect(provider.hasPermission(AdminPermission.manageAccounts), isFalse);
  });

  test('updates employee through repository and refreshes local aggregates', () async {
    final EnterpriseAdminProvider provider = buildProvider(
      repository: FakeEnterpriseAdminRepository(
        data: const EnterpriseAdminOrganizationData(
          employees: <EmployeeRecord>[
            EmployeeRecord(
              id: 'u-live',
              name: '李青',
              employeeNo: 'WL2001',
              departmentId: 'dept-rd',
              departmentName: '研发部',
              positionId: 'position-flutter-engineer',
              positionName: 'Flutter 工程师',
              phone: '13800001234',
              email: 'liqing@worklink.local',
              status: 'Active',
            ),
          ],
          departments: <DepartmentRecord>[
            DepartmentRecord(
              id: 'dept-rd',
              name: '研发部',
              leader: '',
              memberCount: 0,
              description: '',
            ),
            DepartmentRecord(
              id: 'dept-hr',
              name: '人力资源部',
              leader: '',
              memberCount: 0,
              description: '',
            ),
          ],
          positions: <PositionRecord>[
            PositionRecord(
              id: 'position-flutter-engineer',
              title: 'Flutter 工程师',
              level: 'P5',
              departmentName: '研发部',
              headcount: 1,
              openQuota: 0,
            ),
          ],
          accounts: <AccountRecord>[],
        ),
      ),
    );

    provider.syncSession(
      UserModel(
        id: 'u_me',
        name: '张三',
        avatar: 'ZS',
        department: '研发部',
        loginId: 'zhangsan',
        departmentId: 'dept-rd',
        role: 'departmentManager',
        permissions: const <String>['manageEmployees', 'viewDashboard'],
      ),
    );
    await Future<void>.delayed(Duration.zero);

    final EmployeeRecord updated = await provider.updateEmployeeRecord(
      employeeId: 'u-live',
      departmentId: 'dept-hr',
      position: 'HRBP',
      email: 'liqing.hr@worklink.local',
      phone: '13900009999',
    );

    expect(updated.departmentId, 'dept-hr');
    expect(provider.employees.single.departmentName, '人力资源部');
    expect(provider.employees.single.positionName, 'HRBP');
    expect(provider.employees.single.phone, '13900009999');
    expect(
      provider.departments.singleWhere((DepartmentRecord item) => item.id == 'dept-rd').memberCount,
      0,
    );
    expect(
      provider.departments.singleWhere((DepartmentRecord item) => item.id == 'dept-hr').memberCount,
      1,
    );
  });

  test('updates department and syncs employee and position labels', () async {
    final EnterpriseAdminProvider provider = buildProvider(
      repository: FakeEnterpriseAdminRepository(
        data: const EnterpriseAdminOrganizationData(
          employees: <EmployeeRecord>[
            EmployeeRecord(
              id: 'u-live',
              name: '李青',
              employeeNo: 'WL2001',
              departmentId: 'dept-rd',
              departmentName: '研发部',
              positionId: 'position-flutter-engineer',
              positionName: 'Flutter 工程师',
              phone: '13800001234',
              email: 'liqing@worklink.local',
              status: 'Active',
            ),
          ],
          departments: <DepartmentRecord>[
            DepartmentRecord(
              id: 'dept-rd',
              name: '研发部',
              leader: '张三',
              memberCount: 1,
              description: '研发与交付',
            ),
          ],
          positions: <PositionRecord>[
            PositionRecord(
              id: 'position-flutter-engineer',
              title: 'Flutter 工程师',
              level: 'P5',
              departmentName: '研发部',
              headcount: 1,
              openQuota: 0,
            ),
          ],
          accounts: <AccountRecord>[],
        ),
      ),
    );

    provider.syncSession(
      UserModel(
        id: 'u_madao',
        name: 'madao',
        avatar: 'MD',
        department: '平台',
        loginId: 'madao',
        departmentId: 'dept-rd',
        role: 'superAdmin',
        permissions: const <String>['manageDepartments', 'viewDashboard'],
      ),
    );
    await Future<void>.delayed(Duration.zero);

    final DepartmentRecord updated = await provider.updateDepartmentRecord(
      departmentId: 'dept-rd',
      name: '平台研发中心',
      leader: '王五',
      description: '负责平台与业务研发',
    );

    expect(updated.name, '平台研发中心');
    expect(provider.departments.single.name, '平台研发中心');
    expect(provider.departments.single.leader, '王五');
    expect(provider.employees.single.departmentName, '平台研发中心');
    expect(provider.positions.single.departmentName, '平台研发中心');
  });

  test('updates position and syncs employee position labels', () async {
    final EnterpriseAdminProvider provider = buildProvider(
      repository: FakeEnterpriseAdminRepository(
        data: const EnterpriseAdminOrganizationData(
          employees: <EmployeeRecord>[
            EmployeeRecord(
              id: 'u-live',
              name: 'Li Qing',
              employeeNo: 'WL2001',
              departmentId: 'dept-rd',
              departmentName: '研发部',
              positionId: 'position-dept-rd-flutter-engineer',
              positionName: 'Flutter 工程师',
              phone: '13800001234',
              email: 'liqing@worklink.local',
              status: 'Active',
            ),
          ],
          departments: <DepartmentRecord>[
            DepartmentRecord(
              id: 'dept-rd',
              name: '研发部',
              leader: '张三',
              memberCount: 1,
              description: '研发与交付',
            ),
          ],
          positions: <PositionRecord>[
            PositionRecord(
              id: 'position-dept-rd-flutter-engineer',
              title: 'Flutter 工程师',
              level: 'P5',
              departmentName: '研发部',
              headcount: 1,
              openQuota: 0,
            ),
          ],
          accounts: <AccountRecord>[],
        ),
      ),
    );

    provider.syncSession(
      UserModel(
        id: 'u_madao',
        name: 'madao',
        avatar: 'MD',
        department: '平台',
        loginId: 'madao',
        departmentId: 'dept-rd',
        role: 'superAdmin',
        permissions: const <String>['managePositions', 'viewDashboard'],
      ),
    );
    await Future<void>.delayed(Duration.zero);

    final PositionRecord updated = await provider.updatePositionRecord(
      positionId: 'position-dept-rd-flutter-engineer',
      title: 'Flutter 研发专家',
      level: 'P6',
      openQuota: 2,
    );

    expect(updated.title, 'Flutter 研发专家');
    expect(updated.level, 'P6');
    expect(updated.openQuota, 2);
    expect(provider.positions.single.title, 'Flutter 研发专家');
    expect(provider.employees.single.positionId, 'position-dept-rd-flutter-engineer');
    expect(provider.employees.single.positionName, 'Flutter 研发专家');
  });

  test('updates account and refreshes current session permissions when self changes', () async {
    final EnterpriseAdminProvider provider = buildProvider(
      repository: FakeEnterpriseAdminRepository(
        data: const EnterpriseAdminOrganizationData(
          employees: <EmployeeRecord>[],
          departments: <DepartmentRecord>[],
          positions: <PositionRecord>[],
          accounts: <AccountRecord>[
            AccountRecord(
              id: 'account-u_madao',
              name: 'madao',
              loginId: 'madao',
              role: AccountRole.superAdmin,
              enabled: true,
              boundUserIds: <String>['u_madao'],
              boundNames: <String>['madao'],
              boundDepartmentIds: <String>['dept-rd'],
            ),
          ],
        ),
      ),
    );

    provider.syncSession(
      UserModel(
        id: 'u_madao',
        name: 'madao',
        avatar: 'MD',
        department: '平台',
        loginId: 'madao',
        departmentId: 'dept-rd',
        role: 'superAdmin',
        permissions: const <String>['manageAccounts', 'viewDashboard'],
      ),
    );
    await Future<void>.delayed(Duration.zero);

    final AccountRecord updated = await provider.updateAccountRecord(
      userId: 'u_madao',
      role: AccountRole.viewer,
      enabled: false,
    );

    expect(updated.role, AccountRole.viewer);
    expect(updated.enabled, isFalse);
    expect(provider.accounts.single.role, AccountRole.viewer);
    expect(provider.accounts.single.enabled, isFalse);
    expect(provider.currentRole, AccountRole.viewer);
    expect(provider.currentPermissions, isEmpty);
  });
}

class FakeEnterpriseAdminRepository implements EnterpriseAdminRepository {
  FakeEnterpriseAdminRepository({
    this.data = const EnterpriseAdminOrganizationData(
      employees: <EmployeeRecord>[],
      departments: <DepartmentRecord>[],
      positions: <PositionRecord>[],
      accounts: <AccountRecord>[],
    ),
    this.shouldThrow = false,
  });

  final EnterpriseAdminOrganizationData data;
  final bool shouldThrow;

  @override
  Future<EnterpriseAdminOrganizationData> fetchOrganizationData() async {
    if (shouldThrow) {
      throw Exception('boom');
    }
    return data;
  }

  @override
  Future<List<ChangeRequestRecord>> fetchChangeRequests() async {
    return <ChangeRequestRecord>[
      ChangeRequestRecord(
        id: 'cr-1',
        requestNo: 'CR-TEST-001',
        entityType: 'employee',
        entityId: 'u-live',
        entityName: 'Li Qing',
        changeType: 'profile_fix',
        note: 'Update phone',
        status: 'DRAFTED',
        requesterName: 'madao',
        submittedAt: DateTime(2026, 4, 7, 9, 0),
      ),
    ];
  }

  @override
  Future<ChangeRequestDetailRecord> fetchChangeRequestDetail(String requestId) async {
    return ChangeRequestDetailRecord(
      id: requestId,
      requestNo: 'CR-TEST-001',
      entityType: 'employee',
      entityId: 'u-live',
      entityName: 'Li Qing',
      changeType: 'profile_fix',
      note: 'Update phone',
      status: 'DRAFTED',
      requesterName: 'madao',
      submittedAt: DateTime(2026, 4, 7, 9, 0),
      snapshot: const <String, String>{
        'phone': '13800001234',
      },
    );
  }

  @override
  Future<ChangeRequestDetailRecord> approveChangeRequest(String requestId) {
    return fetchChangeRequestDetail(requestId).then(
      (ChangeRequestDetailRecord detail) => ChangeRequestDetailRecord(
        id: detail.id,
        requestNo: detail.requestNo,
        entityType: detail.entityType,
        entityId: detail.entityId,
        entityName: detail.entityName,
        changeType: detail.changeType,
        note: detail.note,
        status: 'APPLIED',
        requesterName: detail.requesterName,
        submittedAt: detail.submittedAt,
        snapshot: detail.snapshot,
      ),
    );
  }

  @override
  Future<ChangeRequestDetailRecord> rejectChangeRequest(String requestId) {
    return fetchChangeRequestDetail(requestId).then(
      (ChangeRequestDetailRecord detail) => ChangeRequestDetailRecord(
        id: detail.id,
        requestNo: detail.requestNo,
        entityType: detail.entityType,
        entityId: detail.entityId,
        entityName: detail.entityName,
        changeType: detail.changeType,
        note: detail.note,
        status: 'REJECTED',
        requesterName: detail.requesterName,
        submittedAt: detail.submittedAt,
        snapshot: detail.snapshot,
      ),
    );
  }

  @override
  Future<EmployeeRecord> updateEmployee({
    required String employeeId,
    required String departmentId,
    required String position,
    required String email,
    required String phone,
  }) async {
    final EmployeeRecord original = data.employees.firstWhere(
      (EmployeeRecord item) => item.id == employeeId,
    );
    final DepartmentRecord department = data.departments.firstWhere(
      (DepartmentRecord item) => item.id == departmentId,
    );
    return original.copyWith(
      departmentId: departmentId,
      departmentName: department.name,
      positionId: 'position-${position.toLowerCase().replaceAll(' ', '-')}',
      positionName: position,
      email: email,
      phone: phone,
    );
  }

  @override
  Future<DepartmentRecord> updateDepartment({
    required String departmentId,
    required String name,
    required String leader,
    required String description,
  }) async {
    final DepartmentRecord original = data.departments.firstWhere(
      (DepartmentRecord item) => item.id == departmentId,
    );
    return original.copyWith(
      name: name,
      leader: leader,
      description: description,
    );
  }

  @override
  Future<AccountRecord> updateAccount({
    required String userId,
    required AccountRole role,
    required bool enabled,
  }) async {
    final AccountRecord original = data.accounts.firstWhere(
      (AccountRecord item) => item.boundUserIds.contains(userId),
    );
    return original.copyWith(role: role, enabled: enabled);
  }

  @override
  Future<PositionRecord> updatePosition({
    required String positionId,
    required String title,
    required String level,
    required int openQuota,
  }) async {
    final PositionRecord original = data.positions.firstWhere(
      (PositionRecord item) => item.id == positionId,
    );
    return original.copyWith(
      title: title,
      level: level,
      openQuota: openQuota,
    );
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
    return ChangeRequestReceipt(
      id: 'cr-test',
      requestNo: 'CR-TEST-001',
      entityType: entityType,
      entityId: entityId,
      entityName: entityName,
      changeType: changeType,
      note: note,
      status: 'DRAFTED',
      submittedAt: DateTime(2025, 1, 1),
    );
  }
}
