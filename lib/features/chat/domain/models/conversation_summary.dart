import 'package:my_first_app/app/shared/models/user_model.dart';

class ConversationSummary {
  const ConversationSummary({
    required this.user,
    required this.latestPreview,
    required this.latestMessageTime,
    required this.unreadCount,
  });

  final UserModel user;
  final String latestPreview;
  final DateTime? latestMessageTime;
  final int unreadCount;

  String get userId => user.id;
  String get name => user.name;
  String get avatar => user.avatar;
  String get department => user.department;
  bool get isOnline => user.isOnline;
  bool get hasUnread => unreadCount > 0;
}
