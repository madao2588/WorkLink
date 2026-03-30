import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/shared/network/api_client.dart';
import 'package:my_first_app/app/shared/network/app_api_config.dart';
import 'package:my_first_app/app/shared/storage/auth_storage.dart';
import 'package:my_first_app/features/approval/data/repositories/approval_repository_impl.dart';
import 'package:my_first_app/features/approval/domain/repositories/approval_repository.dart';
import 'package:my_first_app/features/approval/presentation/providers/approval_provider.dart';
import 'package:my_first_app/features/attendance/presentation/providers/attendance_provider.dart';
import 'package:my_first_app/features/auth/data/auth_repository.dart';
import 'package:my_first_app/features/auth/presentation/providers/user_provider.dart';
import 'package:my_first_app/features/chat/data/repositories/chat_api_repository.dart';
import 'package:my_first_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:my_first_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:my_first_app/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:my_first_app/features/profile/data/profile_repository.dart';
import 'package:my_first_app/features/profile/presentation/providers/profile_provider.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

class WorkLinkBootstrap extends StatelessWidget {
  const WorkLinkBootstrap({super.key, required this.authStorage});

  final LocalAuthStorage authStorage;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(
          create: (_) => ApiClient(baseUrl: AppApiConfig.baseUrl),
        ),
        Provider<LocalAuthStorage>(create: (_) => authStorage),
        Provider<AuthRepository>(
          create: (BuildContext context) =>
              AuthRepository(apiClient: context.read<ApiClient>()),
        ),
        Provider<ProfileRepository>(
          create: (BuildContext context) =>
              ProfileRepository(apiClient: context.read<ApiClient>()),
        ),
        Provider<ApprovalRepository>(
          create: (BuildContext context) =>
              ApprovalRepositoryImpl(apiClient: context.read<ApiClient>()),
        ),
        Provider<ChatRepository>(
          create: (BuildContext context) =>
              ChatApiRepository(apiClient: context.read<ApiClient>()),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (BuildContext context) => UserProvider(
            authRepository: context.read<AuthRepository>(),
            apiClient: context.read<ApiClient>(),
            authStorage: context.read<LocalAuthStorage>(),
          ),
        ),
        ChangeNotifierProxyProvider<UserProvider, ChatProvider>(
          create: (BuildContext context) =>
              ChatProvider(repository: context.read<ChatRepository>()),
          update:
              (
                BuildContext context,
                UserProvider userProvider,
                ChatProvider? provider,
              ) {
                final ChatProvider resolved =
                    provider ??
                    ChatProvider(repository: context.read<ChatRepository>());
                resolved.handleSessionChanged(userProvider.isAuthenticated);
                return resolved;
              },
        ),
        ChangeNotifierProxyProvider<UserProvider, AttendanceProvider>(
          create: (BuildContext context) =>
              AttendanceProvider(apiClient: context.read<ApiClient>()),
          update:
              (
                BuildContext context,
                UserProvider userProvider,
                AttendanceProvider? provider,
              ) {
                final AttendanceProvider resolved =
                    provider ??
                    AttendanceProvider(apiClient: context.read<ApiClient>());
                resolved.handleSessionChanged(userProvider.isAuthenticated);
                return resolved;
              },
        ),
        ChangeNotifierProxyProvider<UserProvider, ApprovalProvider>(
          create: (BuildContext context) =>
              ApprovalProvider(repository: context.read<ApprovalRepository>()),
          update:
              (
                BuildContext context,
                UserProvider userProvider,
                ApprovalProvider? provider,
              ) {
                final ApprovalProvider resolved =
                    provider ??
                    ApprovalProvider(
                      repository: context.read<ApprovalRepository>(),
                    );
                resolved.handleSessionChanged(userProvider.isAuthenticated);
                return resolved;
              },
        ),
        ChangeNotifierProxyProvider<UserProvider, ContactsProvider>(
          create: (BuildContext context) =>
              ContactsProvider(apiClient: context.read<ApiClient>()),
          update:
              (
                BuildContext context,
                UserProvider userProvider,
                ContactsProvider? provider,
              ) {
                final ContactsProvider resolved =
                    provider ??
                    ContactsProvider(apiClient: context.read<ApiClient>());
                resolved.handleSessionChanged(userProvider.isAuthenticated);
                return resolved;
              },
        ),
        ChangeNotifierProxyProvider<UserProvider, ProfileProvider>(
          create: (BuildContext context) =>
              ProfileProvider(repository: context.read<ProfileRepository>()),
          update:
              (
                BuildContext context,
                UserProvider userProvider,
                ProfileProvider? provider,
              ) {
                final ProfileProvider resolved =
                    provider ??
                    ProfileProvider(
                      repository: context.read<ProfileRepository>(),
                    );
                resolved.handleSessionChanged(userProvider.isAuthenticated);
                return resolved;
              },
        ),
      ],
      child: const WorkLinkApp(),
    );
  }
}

class WorkLinkApp extends StatelessWidget {
  const WorkLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = context.watch<UserProvider>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'WorkLink',
      theme: AppTheme.lightTheme,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (
        Locale? locale,
        Iterable<Locale> supportedLocales,
      ) {
        final String? languageCode = locale?.languageCode;
        if (languageCode == 'zh') {
          return const Locale('zh');
        }
        if (languageCode == 'en') {
          return const Locale('en');
        }
        return supportedLocales.first;
      },
      routerConfig: AppRouter.createRouter(userProvider),
    );
  }
}
