enum AdminPermission {
  manageEmployees,
  manageDepartments,
  managePositions,
  manageAccounts,
  exportData,
  viewDashboard,
}

enum AccountRole {
  superAdmin,
  hrManager,
  departmentManager,
  viewer,
}

class EmployeeRecord {
  const EmployeeRecord({
    required this.id,
    required this.name,
    required this.employeeNo,
    required this.departmentId,
    required this.departmentName,
    required this.positionId,
    required this.positionName,
    required this.phone,
    required this.email,
    required this.status,
  });

  final String id;
  final String name;
  final String employeeNo;
  final String departmentId;
  final String departmentName;
  final String positionId;
  final String positionName;
  final String phone;
  final String email;
  final String status;

  EmployeeRecord copyWith({
    String? id,
    String? name,
    String? employeeNo,
    String? departmentId,
    String? departmentName,
    String? positionId,
    String? positionName,
    String? phone,
    String? email,
    String? status,
  }) {
    return EmployeeRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      employeeNo: employeeNo ?? this.employeeNo,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      positionId: positionId ?? this.positionId,
      positionName: positionName ?? this.positionName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }
}

class DepartmentRecord {
  const DepartmentRecord({
    required this.id,
    required this.name,
    required this.leader,
    required this.memberCount,
    required this.description,
  });

  final String id;
  final String name;
  final String leader;
  final int memberCount;
  final String description;

  DepartmentRecord copyWith({
    String? id,
    String? name,
    String? leader,
    int? memberCount,
    String? description,
  }) {
    return DepartmentRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      leader: leader ?? this.leader,
      memberCount: memberCount ?? this.memberCount,
      description: description ?? this.description,
    );
  }
}

class PositionRecord {
  const PositionRecord({
    required this.id,
    required this.title,
    required this.level,
    required this.departmentName,
    required this.headcount,
    required this.openQuota,
  });

  final String id;
  final String title;
  final String level;
  final String departmentName;
  final int headcount;
  final int openQuota;

  PositionRecord copyWith({
    String? id,
    String? title,
    String? level,
    String? departmentName,
    int? headcount,
    int? openQuota,
  }) {
    return PositionRecord(
      id: id ?? this.id,
      title: title ?? this.title,
      level: level ?? this.level,
      departmentName: departmentName ?? this.departmentName,
      headcount: headcount ?? this.headcount,
      openQuota: openQuota ?? this.openQuota,
    );
  }
}

class AccountRecord {
  const AccountRecord({
    required this.id,
    required this.name,
    required this.loginId,
    required this.role,
    required this.enabled,
    this.boundUserIds = const <String>[],
    this.boundNames = const <String>[],
    this.boundDepartmentIds = const <String>[],
  });

  final String id;
  final String name;
  final String loginId;
  final AccountRole role;
  final bool enabled;
  final List<String> boundUserIds;
  final List<String> boundNames;
  final List<String> boundDepartmentIds;

  AccountRecord copyWith({
    String? id,
    String? name,
    String? loginId,
    AccountRole? role,
    bool? enabled,
    List<String>? boundUserIds,
    List<String>? boundNames,
    List<String>? boundDepartmentIds,
  }) {
    return AccountRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      loginId: loginId ?? this.loginId,
      role: role ?? this.role,
      enabled: enabled ?? this.enabled,
      boundUserIds: boundUserIds ?? this.boundUserIds,
      boundNames: boundNames ?? this.boundNames,
      boundDepartmentIds: boundDepartmentIds ?? this.boundDepartmentIds,
    );
  }
}

class ChangeRequestReceipt {
  const ChangeRequestReceipt({
    required this.id,
    required this.requestNo,
    required this.entityType,
    required this.entityId,
    required this.entityName,
    required this.changeType,
    required this.note,
    required this.status,
    required this.submittedAt,
  });

  final String id;
  final String requestNo;
  final String entityType;
  final String entityId;
  final String entityName;
  final String changeType;
  final String note;
  final String status;
  final DateTime submittedAt;
}

class ChangeRequestRecord {
  const ChangeRequestRecord({
    required this.id,
    required this.requestNo,
    required this.entityType,
    required this.entityId,
    required this.entityName,
    required this.changeType,
    required this.note,
    required this.status,
    required this.requesterName,
    required this.submittedAt,
  });

  final String id;
  final String requestNo;
  final String entityType;
  final String entityId;
  final String entityName;
  final String changeType;
  final String note;
  final String status;
  final String requesterName;
  final DateTime submittedAt;
}

class ChangeRequestDetailRecord {
  const ChangeRequestDetailRecord({
    required this.id,
    required this.requestNo,
    required this.entityType,
    required this.entityId,
    required this.entityName,
    required this.changeType,
    required this.note,
    required this.status,
    required this.requesterName,
    required this.submittedAt,
    required this.snapshot,
  });

  final String id;
  final String requestNo;
  final String entityType;
  final String entityId;
  final String entityName;
  final String changeType;
  final String note;
  final String status;
  final String requesterName;
  final DateTime submittedAt;
  final Map<String, String> snapshot;
}
