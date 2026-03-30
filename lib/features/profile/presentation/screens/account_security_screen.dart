import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/profile/domain/models/account_security_data.dart';
import 'package:my_first_app/features/profile/presentation/providers/profile_provider.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<ProfileProvider>().loadAccountSecurity();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profile = context.watch<ProfileProvider>();
    final AccountSecurityData? data = profile.accountSecurity;

    return Scaffold(
      appBar: AppBar(title: const Text('账号与安全')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[Color(0xFF123DAE), Color(0xFF2D77F8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              data == null
                  ? '账号安全信息将通过后端安全接口加载。'
                  : '已同步绑定方式、设备信息和安全策略，便于统一管理登录安全。',
              style: TextStyle(
                color: Colors.white.withAlpha(220),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 18),
          if (profile.accountSecurityLoading)
            const Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(),
            ))
          else if (profile.accountSecurityError != null)
            _buildMessageCard(profile.accountSecurityError!)
          else if (data == null)
            _buildMessageCard('暂无账号安全数据')
          else ...<Widget>[
            _SectionCard(
              title: '账号信息',
              child: Column(
                children: <Widget>[
                  _InfoRow(label: '绑定手机', value: data.mobileMasked),
                  _InfoRow(label: '绑定邮箱', value: data.emailMasked),
                  _InfoRow(
                    label: '密码更新时间',
                    value: DateFormat('yyyy-MM-dd').format(data.passwordUpdatedAt),
                  ),
                  _InfoRow(
                    label: '多因素认证',
                    value: data.mfaEnabled ? '已开启' : '未开启',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '最近登录设备',
              child: Column(
                children: data.devices.map((LoginDeviceItem device) {
                  return _DeviceTile(device: device);
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageCard(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        message,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({required this.device});

  final LoginDeviceItem device;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.brandBlue.withAlpha(14),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.devices_outlined, color: AppColors.brandBlue),
      ),
      title: Text(
        '${device.name} · ${device.platform}',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(device.lastLoginAt)),
      trailing: device.isCurrent
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(16),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                '当前设备',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : null,
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: <Widget>[
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
