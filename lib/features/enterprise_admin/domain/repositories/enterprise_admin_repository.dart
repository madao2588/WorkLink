import 'package:my_first_app/features/enterprise_admin/domain/models/enterprise_admin_models.dart';

class EnterpriseAdminOrganizationData {
  const EnterpriseAdminOrganizationData({
    required this.employees,
    required this.departments,
    required this.positions,
    required this.accounts,
  });

  final List<EmployeeRecord> employees;
  final List<DepartmentRecord> departments;
  final List<PositionRecord> positions;
  final List<AccountRecord> accounts;
}

abstract class EnterpriseAdminRepository {
  Future<EnterpriseAdminOrganizationData> fetchOrganizationData();

  Future<List<ChangeRequestRecord>> fetchChangeRequests();

  Future<ChangeRequestDetailRecord> fetchChangeRequestDetail(String requestId);

  Future<ChangeRequestDetailRecord> approveChangeRequest(String requestId);

  Future<ChangeRequestDetailRecord> rejectChangeRequest(String requestId);

  Future<EmployeeRecord> updateEmployee({
    required String employeeId,
    required String departmentId,
    required String position,
    required String email,
    required String phone,
  });

  Future<DepartmentRecord> updateDepartment({
    required String departmentId,
    required String name,
    required String leader,
    required String description,
  });

  Future<AccountRecord> updateAccount({
    required String userId,
    required AccountRole role,
    required bool enabled,
  });

  Future<PositionRecord> updatePosition({
    required String positionId,
    required String title,
    required String level,
    required int openQuota,
  });

  Future<ChangeRequestReceipt> createChangeRequest({
    required String entityType,
    required String entityId,
    required String entityName,
    required String changeType,
    required String note,
    required Map<String, String> snapshot,
  });
}
