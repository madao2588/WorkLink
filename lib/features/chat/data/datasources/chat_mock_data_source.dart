import 'package:my_first_app/app/shared/models/user_model.dart';
import 'package:my_first_app/app/shared/services/mock_service.dart';
import 'package:my_first_app/features/chat/domain/models/chat_message_model.dart';

class ChatMockDataSource {
  List<UserModel> fetchUsers() {
    return MockService.getUsers();
  }

  List<ChatMessageModel> fetchMessages(String userId) {
    return MockService.getMessages(userId);
  }
}
