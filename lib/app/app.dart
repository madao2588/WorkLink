import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

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
import 'package:my_first_app/features/enterprise_admin/data/repositories/enterprise_admin_api_repository.dart';
import 'package:my_first_app/features/enterprise_admin/application/enterprise_excel_export_service.dart';
import 'package:my_first_app/features/enterprise_admin/domain/repositories/enterprise_admin_repository.dart';
import 'package:my_first_app/features/enterprise_admin/presentation/providers/enterprise_admin_provider.dart';
import 'package:my_first_app/features/profile/data/profile_repository.dart';
import 'package:my_first_app/features/profile/presentation/providers/profile_provider.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_mode_controller.dart';
import 'package:my_first_app/app/shared/widgets/app_theme_toggle_button.dart';
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
        Provider<EnterpriseExcelExportService>(
          create: (_) => EnterpriseExcelExportService(),
        ),
        Provider<EnterpriseAdminRepository>(
          create: (BuildContext context) =>
              EnterpriseAdminApiRepository(apiClient: context.read<ApiClient>()),
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
        ChangeNotifierProxyProvider<ProfileProvider, AppThemeModeController>(
          create: (_) => AppThemeModeController(),
          update:
              (
                BuildContext context,
                ProfileProvider profileProvider,
                AppThemeModeController? controller,
              ) {
                final AppThemeModeController resolved =
                    controller ?? AppThemeModeController();
                final String? themeMode = profileProvider.settings?.themeMode;
                if (themeMode != null) {
                  resolved.setThemeModeFromSetting(themeMode);
                }
                return resolved;
              },
        ),
        ChangeNotifierProxyProvider<UserProvider, EnterpriseAdminProvider>(
          create: (BuildContext context) => EnterpriseAdminProvider(
            exportService: context.read<EnterpriseExcelExportService>(),
            repository: context.read<EnterpriseAdminRepository>(),
          ),
          update:
              (
                BuildContext context,
                UserProvider userProvider,
                EnterpriseAdminProvider? provider,
              ) {
                final EnterpriseAdminProvider resolved =
                    provider ??
                    EnterpriseAdminProvider(
                      exportService: context.read<EnterpriseExcelExportService>(),
                      repository: context.read<EnterpriseAdminRepository>(),
                    );
                resolved.syncSession(userProvider.currentUser);
                return resolved;
              },
        ),
      ],
      child: const WorkLinkApp(),
    );
  }
}

class WorkLinkApp extends StatefulWidget {
  const WorkLinkApp({super.key});

  @override
  State<WorkLinkApp> createState() => _WorkLinkAppState();
}

class _WorkLinkAppState extends State<WorkLinkApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(context.read<UserProvider>());
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeModeController themeController =
        context.watch<AppThemeModeController>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'WorkLink',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
            final String? languageCode = locale?.languageCode;
            if (languageCode == 'zh') {
              return const Locale('zh');
            }
            if (languageCode == 'en') {
              return const Locale('en');
            }
            return supportedLocales.first;
          },
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: <Widget>[
            Positioned.fill(child: child ?? const SizedBox.shrink()),
            const Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                minimum: EdgeInsets.fromLTRB(12, 8, 16, 0),
                child: AppThemeCornerButton(),
              ),
            ),
          ],
        );
      },
      routerConfig: _router,
    );
  }
}
