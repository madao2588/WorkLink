import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_first_app/app/main_shell.dart';
import 'package:my_first_app/features/approval/presentation/screens/approval_list_screen.dart';
import 'package:my_first_app/features/auth/presentation/providers/user_provider.dart';
import 'package:my_first_app/features/auth/presentation/screens/login_screen.dart';
import 'package:my_first_app/features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:my_first_app/features/chat/presentation/screens/message_list_screen.dart';
import 'package:my_first_app/features/contacts/presentation/screens/contact_screen.dart';
import 'package:my_first_app/features/profile/presentation/screens/account_security_screen.dart';
import 'package:my_first_app/features/profile/presentation/screens/badges_screen.dart';
import 'package:my_first_app/features/profile/presentation/screens/general_settings_screen.dart';
import 'package:my_first_app/features/profile/presentation/screens/help_feedback_screen.dart';
import 'package:my_first_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:my_first_app/features/profile/presentation/screens/salary_slips_screen.dart';
import 'package:my_first_app/features/workplace/presentation/screens/workplace_screen.dart';

class AppRoutes {
  static const String login = 'login';
  static const String loading = 'loading';
  static const String messages = 'messages';
  static const String contacts = 'contacts';
  static const String workplace = 'workplace';
  static const String profile = 'profile';
  static const String approval = 'approval';
  static const String salarySlips = 'salarySlips';
  static const String badges = 'badges';
  static const String accountSecurity = 'accountSecurity';
  static const String generalSettings = 'generalSettings';
  static const String helpFeedback = 'helpFeedback';
  static const String chatDetail = 'chatDetail';
}

class AppRouter {
  static GoRouter createRouter(UserProvider userProvider) {
    return GoRouter(
      initialLocation: '/messages',
      refreshListenable: userProvider,
      redirect: (context, state) {
        final bool loggedIn = userProvider.currentUser != null;
        final bool goingToLogin = state.matchedLocation == '/login';
        final bool goingToLoading = state.matchedLocation == '/loading';

        // Avoid redirect flicker while we restore/refresh auth tokens.
        if (userProvider.isLoading) {
          return goingToLoading ? null : '/loading';
        }

        // Auth restored/finished: leave the loading page.
        if (goingToLoading) {
          return loggedIn ? '/messages' : '/login';
        }

        if (!loggedIn && !goingToLogin) {
          return '/login';
        }
        if (loggedIn && goingToLogin) {
          return '/messages';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/loading',
          name: AppRoutes.loading,
          builder: (context, state) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        GoRoute(
          path: '/login',
          name: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/messages',
                  name: AppRoutes.messages,
                  builder: (context, state) => const MessageListScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/contacts',
                  name: AppRoutes.contacts,
                  builder: (context, state) => const ContactScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/workplace',
                  name: AppRoutes.workplace,
                  builder: (context, state) => const WorkplaceScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  name: AppRoutes.profile,
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/approval',
          name: AppRoutes.approval,
          builder: (context, state) => const ApprovalListScreen(),
        ),
        GoRoute(
          path: '/salary-slips',
          name: AppRoutes.salarySlips,
          builder: (context, state) => const SalarySlipsScreen(),
        ),
        GoRoute(
          path: '/badges',
          name: AppRoutes.badges,
          builder: (context, state) => const BadgesScreen(),
        ),
        GoRoute(
          path: '/account-security',
          name: AppRoutes.accountSecurity,
          builder: (context, state) => const AccountSecurityScreen(),
        ),
        GoRoute(
          path: '/general-settings',
          name: AppRoutes.generalSettings,
          builder: (context, state) => const GeneralSettingsScreen(),
        ),
        GoRoute(
          path: '/help-feedback',
          name: AppRoutes.helpFeedback,
          builder: (context, state) => const HelpFeedbackScreen(),
        ),
        GoRoute(
          path: '/chat/:userId',
          name: AppRoutes.chatDetail,
          builder: (context, state) {
            final String userId = state.pathParameters['userId']!;
            return ChatDetailScreen(
              userId: userId,
            );
          },
        ),
      ],
    );
  }
}
