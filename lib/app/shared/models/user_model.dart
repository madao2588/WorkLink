class UserModel {
  final String id;
  final String name;
  final String avatar;
  final String department;
  final String? loginId;
  final String? departmentId;
  final String? position;
  final String? employeeNo;
  final String? email;
  final String? mobileMasked;
  final String? role;
  final List<String> permissions;
  final bool isOnline;

  UserModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.department,
    this.loginId,
    this.departmentId,
    this.position,
    this.employeeNo,
    this.email,
    this.mobileMasked,
    this.role,
    this.permissions = const <String>[],
    this.isOnline = false,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? department,
    String? loginId,
    String? departmentId,
    String? position,
    String? employeeNo,
    String? email,
    String? mobileMasked,
    String? role,
    List<String>? permissions,
    bool? isOnline,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      department: department ?? this.department,
      loginId: loginId ?? this.loginId,
      departmentId: departmentId ?? this.departmentId,
      position: position ?? this.position,
      employeeNo: employeeNo ?? this.employeeNo,
      email: email ?? this.email,
      mobileMasked: mobileMasked ?? this.mobileMasked,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
