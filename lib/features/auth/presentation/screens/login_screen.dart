import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/approval/presentation/providers/approval_provider.dart';
import 'package:my_first_app/features/attendance/presentation/providers/attendance_provider.dart';
import 'package:my_first_app/features/auth/presentation/providers/user_provider.dart';
import 'package:my_first_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:my_first_app/features/contacts/presentation/providers/contacts_provider.dart';

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
        const SnackBar(content: Text('Please enter account and password')),
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
        SnackBar(content: Text(userProvider.errorMessage ?? 'Login failed')),
      );
      return;
    }

    await Future.wait(<Future<void>>[
      context.read<ChatProvider>().refresh(),
      context.read<ApprovalProvider>().loadApprovals(),
      context.read<AttendanceProvider>().loadToday(),
      context.read<ContactsProvider>().loadContacts(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = context.watch<UserProvider>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(color: AppColors.background),
                    ),
                    Positioned(
                      top: -140,
                      left: -60,
                      right: -60,
                      child: Container(
                        height: 360,
                        decoration: const BoxDecoration(
                          gradient: AppColors.heroGradient,
                          borderRadius: BorderRadius.vertical(
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
                            _buildHeroHeader(),
                            const SizedBox(height: 28),
                            _buildLoginCard(userProvider),
                            const Spacer(),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                'Demo account: zhangsan / 123456',
                                style: TextStyle(
                                  color: AppColors.textSecondary.withAlpha(170),
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

  Widget _buildHeroHeader() {
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
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.hub_outlined, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'WORKLINK',
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
        const Text(
          'Connected Team Workflow',
          style: TextStyle(
            fontSize: 30,
            height: 1.2,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Sign in to sync messages, approvals, attendance, contacts, and your workspace dashboard.',
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.white.withAlpha(220),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(UserProvider userProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF1456F0).withAlpha(22),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
        border: Border.all(color: Colors.white.withAlpha(200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Welcome back',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Use the backend demo account to enter the connected workspace.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _accountController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Account',
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
            decoration: const InputDecoration(
              labelText: 'Password',
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
                userProvider.isLoading ? 'Connecting...' : 'Enter WorkLink',
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
