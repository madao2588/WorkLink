import 'package:my_first_app/app/shared/models/user_model.dart';
import 'package:my_first_app/features/chat/domain/models/chat_message_model.dart';

class MockService {
  static List<UserModel> getUsers() {
    return [
      UserModel(
        id: '1',
        name: '张三',
        avatar: 'ZS',
        department: '研发部',
        isOnline: true,
      ),
      UserModel(
        id: '2',
        name: '李四',
        avatar: 'LS',
        department: '市场部',
        isOnline: false,
      ),
      UserModel(
        id: '3',
        name: '王五',
        avatar: 'WW',
        department: '人事部',
        isOnline: true,
      ),
      UserModel(
        id: '4',
        name: '赵六',
        avatar: 'ZL',
        department: '财务部',
        isOnline: true,
      ),
    ];
  }

  static List<ChatMessageModel> getMessages(String userId) {
    switch (userId) {
      case '1':
        return <ChatMessageModel>[
          ChatMessageModel(
            id: '1-1',
            senderId: userId,
            content: '早上好，今天的版本回归我已经开始跑了。',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            isMe: false,
            isRead: true,
          ),
          ChatMessageModel(
            id: '1-2',
            senderId: 'me',
            content: '好，辛苦你，跑完把结果同步到群里。',
            timestamp: DateTime.now().subtract(
              const Duration(hours: 1, minutes: 48),
            ),
            isMe: true,
            isRead: true,
          ),
          ChatMessageModel(
            id: '1-3',
            senderId: userId,
            content: '收到，顺便帮你把异常日志单独整理出来。',
            timestamp: DateTime.now().subtract(
              const Duration(minutes: 24),
            ),
            isMe: false,
            isRead: false,
          ),
        ];
      case '2':
        return <ChatMessageModel>[
          ChatMessageModel(
            id: '2-1',
            senderId: 'me',
            content: '市场活动页的视觉稿已经发你邮箱了。',
            timestamp: DateTime.now().subtract(
              const Duration(hours: 5, minutes: 10),
            ),
            isMe: true,
            isRead: true,
          ),
          ChatMessageModel(
            id: '2-2',
            senderId: userId,
            content: '看到了，下午我补一下活动文案。',
            timestamp: DateTime.now().subtract(
              const Duration(hours: 4, minutes: 58),
            ),
            isMe: false,
            isRead: true,
          ),
        ];
      case '3':
        return <ChatMessageModel>[
          ChatMessageModel(
            id: '3-1',
            senderId: userId,
            content: '你这周的请假流程已经帮你预审过了。',
            timestamp: DateTime.now().subtract(
              const Duration(hours: 3, minutes: 20),
            ),
            isMe: false,
            isRead: true,
          ),
          ChatMessageModel(
            id: '3-2',
            senderId: userId,
            content: '有空的时候再补一下出差时间范围就行。',
            timestamp: DateTime.now().subtract(
              const Duration(minutes: 42),
            ),
            isMe: false,
            isRead: false,
          ),
        ];
      case '4':
        return <ChatMessageModel>[
          ChatMessageModel(
            id: '4-1',
            senderId: 'me',
            content: '上月报销汇总表我已经重新上传了。',
            timestamp: DateTime.now().subtract(
              const Duration(days: 1, hours: 1),
            ),
            isMe: true,
            isRead: true,
          ),
          ChatMessageModel(
            id: '4-2',
            senderId: userId,
            content: '好的，我这边核对完再回你。',
            timestamp: DateTime.now().subtract(
              const Duration(days: 1, minutes: 20),
            ),
            isMe: false,
            isRead: true,
          ),
        ];
      default:
        return <ChatMessageModel>[];
    }
  }
}
