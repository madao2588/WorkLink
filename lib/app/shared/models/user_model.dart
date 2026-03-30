class UserModel {
  final String id;
  final String name;
  final String avatar;
  final String department;
  final bool isOnline;

  UserModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.department,
    this.isOnline = false,
  });
}