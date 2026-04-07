import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/l10n/app_localizations.dart';
import 'package:my_first_app/features/auth/presentation/providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _accountController = TextEditingController(
    text: 'zhangsan',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: '123456',
  );

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final String account = _accountController.text.trim();
    final String password = _passwordController.text.trim();
    if (account.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.loginPleaseEnterAccountAndPassword,
          ),
        ),
      );
      return;
    }

    final UserProvider userProvider = context.read<UserProvider>();
    final bool success = await userProvider.login(
      loginId: account,
      password: password,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            userProvider.errorMessage ??
                AppLocalizations.of(context)!.loginFailed,
          ),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = context.watch<UserProvider>();
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool darkMode = AppThemePalette.isDark(context);
    final Color pageBackground = AppThemePalette.pageBackground(context);
    final Color secondaryText = AppThemePalette.textSecondary(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(child: Container(color: pageBackground)),
                    Positioned(
                      top: -140,
                      left: -60,
                      right: -60,
                      child: Container(
                        height: 360,
                        decoration: BoxDecoration(
                          gradient: AppThemePalette.heroGradient(context),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(56),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 120,
                      right: -40,
                      child: _buildGlowCircle(
                        size: 180,
                        color: Colors.white.withAlpha(35),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: -20,
                      child: _buildGlowCircle(
                        size: 120,
                        color: AppColors.accentCyan.withAlpha(70),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 16),
                            _buildHeroHeader(l10n),
                            const SizedBox(height: 28),
                            _buildLoginCard(userProvider, darkMode: darkMode),
                            const Spacer(),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                l10n.loginDemoAccount,
                                style: TextStyle(
                                  color: secondaryText.withAlpha(170),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroHeader(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(30),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withAlpha(45)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.hub_outlined, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                l10n.loginHeroBrand,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(
          l10n.loginHeroTitle,
          style: TextStyle(
            fontSize: 30,
            height: 1.2,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.loginHeroSubtitle,
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.white.withAlpha(220),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(UserProvider userProvider, {required bool darkMode}) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Color cardSurface = AppThemePalette.surface(context);
    final Color borderColor = AppThemePalette.border(context);
    final Color titleColor = AppThemePalette.textPrimary(context);
    final Color subtitleColor = AppThemePalette.textSecondary(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardSurface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: (darkMode ? const Color(0xFF0A1220) : const Color(0xFF1456F0))
                .withAlpha(darkMode ? 34 : 22),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.loginTitleWelcomeBack,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.loginSubtitleDemoAccount,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _accountController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: l10n.loginLabelAccount,
              hintText: 'zhangsan',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleLogin(),
            decoration: InputDecoration(
              labelText: l10n.loginLabelPassword,
              hintText: '123456',
              prefixIcon: Icon(Icons.lock_outline_rounded),
            ),
          ),
          if (userProvider.errorMessage != null) ...<Widget>[
            const SizedBox(height: 14),
            Text(
              userProvider.errorMessage!,
              style: const TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: userProvider.isLoading ? null : _handleLogin,
              child: Text(
                userProvider.isLoading
                    ? l10n.loginConnecting
                    : l10n.loginEnterWorkLink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowCircle({required double size, required Color color}) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
