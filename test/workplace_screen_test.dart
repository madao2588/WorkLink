import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/shared/models/user_model.dart';
import 'package:my_first_app/app/shared/network/api_client.dart';
import 'package:my_first_app/app/shared/storage/auth_storage.dart';
import 'package:my_first_app/features/approval/domain/models/approval_model.dart';
import 'package:my_first_app/features/approval/domain/repositories/approval_repository.dart';
import 'package:my_first_app/features/approval/presentation/providers/approval_provider.dart';
import 'package:my_first_app/features/attendance/presentation/providers/attendance_provider.dart';
import 'package:my_first_app/features/auth/data/auth_repository.dart';
import 'package:my_first_app/features/auth/presentation/providers/user_provider.dart';
import 'package:my_first_app/features/chat/domain/models/chat_message_model.dart';
import 'package:my_first_app/features/chat/domain/models/conversation_summary.dart';
import 'package:my_first_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:my_first_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:my_first_app/features/workplace/presentation/screens/workplace_screen.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

void main() {
  testWidgets(
    'workplace screen renders and scrolls without layout exceptions',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<UserProvider>(
              create: (_) => _TestUserProvider(),
            ),
            ChangeNotifierProvider<AttendanceProvider>(
              create: (_) => AttendanceProvider(
                apiClient: ApiClient(baseUrl: 'http://127.0.0.1:8000/api/v1'),
              ),
            ),
            ChangeNotifierProvider<ApprovalProvider>(
              create: (_) =>
                  ApprovalProvider(repository: _FakeApprovalRepository()),
            ),
            ChangeNotifierProvider<ChatProvider>(
              create: (_) => ChatProvider(repository: _FakeChatRepository()),
            ),
          ],
          child: MaterialApp(
            locale: const Locale('zh'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const WorkplaceScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(CustomScrollView), findsOneWidget);

      final ScrollableState scrollable = tester.state<ScrollableState>(
        find.byType(Scrollable),
      );
      expect(scrollable.position.pixels, 0);

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -1200));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(scrollable.position.pixels, greaterThan(0));
    },
  );
}

class _TestUserProvider extends UserProvider {
  _TestUserProvider()
    : super(
        authRepository: AuthRepository(
          apiClient: ApiClient(baseUrl: 'http://127.0.0.1:8000/api/v1'),
        ),
        apiClient: ApiClient(baseUrl: 'http://127.0.0.1:8000/api/v1'),
        authStorage: _InMemoryAuthStorage(),
      );

  static final UserModel _user = UserModel(
    id: 'u_test',
    name: 'Test User',
    avatar: 'TU',
    department: 'Engineering',
    loginId: 'zhangsan',
    isOnline: true,
  );

  @override
  UserModel? get currentUser => _user;
}

class _InMemoryAuthStorage extends LocalAuthStorage {
  _InMemoryAuthStorage();

  String? _accessToken;
  String? _refreshToken;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  @override
  Future<String?> readAccessToken() async => _accessToken;

  @override
  Future<String?> readRefreshToken() async => _refreshToken;

  @override
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
  }
}

class _FakeApprovalRepository implements ApprovalRepository {
  final List<ApprovalModel> _approvals = <ApprovalModel>[
    ApprovalModel(
      id: 'approval-1',
      title: 'Leave Approval',
      applicant: 'Li Si',
      startTime: DateTime(2026, 4, 3, 9, 30),
      reason: 'Family matter',
      status: ApprovalStatus.pending,
    ),
    ApprovalModel(
      id: 'approval-2',
      title: 'Expense Approval',
      applicant: 'Wang Wu',
      startTime: DateTime(2026, 4, 3, 11, 20),
      reason: 'Travel expense',
      status: ApprovalStatus.approved,
    ),
  ];

  @override
  List<ApprovalModel> getApprovals() =>
      List<ApprovalModel>.unmodifiable(_approvals);

  @override
  int get pendingCount => _approvals
      .where((ApprovalModel item) => item.status == ApprovalStatus.pending)
      .length;

  @override
  int get approvedCount => _approvals
      .where((ApprovalModel item) => item.status == ApprovalStatus.approved)
      .length;

  @override
  int get rejectedCount => _approvals
      .where((ApprovalModel item) => item.status == ApprovalStatus.rejected)
      .length;

  @override
  Future<void> loadApprovals() async {}

  @override
  Future<void> submitLeave(String reason) async {}

  @override
  Future<void> approve(String id) async {}

  @override
  Future<void> reject(String id) async {}
}

class _FakeChatRepository implements ChatRepository {
  final List<ConversationSummary> _summaries = <ConversationSummary>[
    ConversationSummary(
      user: UserModel(
        id: 'u_1',
        name: 'Zhang San',
        avatar: 'ZS',
        department: 'Engineering',
        isOnline: true,
      ),
      latestPreview: 'The approval note is updated.',
      latestMessageTime: DateTime(2026, 4, 3, 10, 40),
      unreadCount: 2,
    ),
    ConversationSummary(
      user: UserModel(
        id: 'u_2',
        name: 'Wang Wu',
        avatar: 'WW',
        department: 'HR',
        isOnline: false,
      ),
      latestPreview: 'Today announcement has been synced.',
      latestMessageTime: DateTime(2026, 4, 3, 9, 10),
      unreadCount: 0,
    ),
  ];

  @override
  List<UserModel> getUsers() => _summaries
      .map((ConversationSummary summary) => summary.user)
      .toList(growable: false);

  @override
  List<ConversationSummary> getConversationSummaries() =>
      List<ConversationSummary>.unmodifiable(_summaries);

  @override
  List<ChatMessageModel> getMessages(String userId) =>
      const <ChatMessageModel>[];

  @override
  int unreadCountFor(String userId) => _summaries
      .where((ConversationSummary summary) => summary.userId == userId)
      .map((ConversationSummary summary) => summary.unreadCount)
      .fold<int>(0, (int current, int count) => current + count);

  @override
  DateTime? latestMessageTimeFor(String userId) {
    for (final ConversationSummary summary in _summaries) {
      if (summary.userId == userId) {
        return summary.latestMessageTime;
      }
    }
    return null;
  }

  @override
  String latestPreviewFor(String userId) {
    for (final ConversationSummary summary in _summaries) {
      if (summary.userId == userId) {
        return summary.latestPreview;
      }
    }
    return '';
  }

  @override
  int get totalMessageCount => _summaries.fold<int>(
    0,
    (int total, ConversationSummary summary) => total + summary.unreadCount,
  );

  @override
  int get unreadConversationCount => _summaries
      .where((ConversationSummary summary) => summary.unreadCount > 0)
      .length;

  @override
  Future<void> loadConversations() async {}

  @override
  Future<void> loadMessages(String userId) async {}

  @override
  Future<void> markConversationRead(String userId) async {}

  @override
  Future<void> sendMessage(String userId, String content) async {}
}
