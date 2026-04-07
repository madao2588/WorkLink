import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/profile/domain/models/account_security_data.dart';
import 'package:my_first_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ProfileProvider profile = context.watch<ProfileProvider>();
    final AccountSecurityData? data = profile.accountSecurity;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountSecurityTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: AppThemePalette.heroGradient(context),
              borderRadius: BorderRadius.circular(30),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppThemePalette.heroShadow(context),
                  blurRadius: 28,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Text(
              data == null
                  ? l10n.accountSecurityIntroEmpty
                  : l10n.accountSecurityIntroLoaded,
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
            _buildMessageCard(l10n.accountSecurityEmpty)
          else ...<Widget>[
            _SectionCard(
              title: l10n.accountSecuritySectionAccountInfo,
              child: Column(
                children: <Widget>[
                  _InfoRow(label: l10n.accountSecurityLabelMobile, value: data.mobileMasked),
                  _InfoRow(label: l10n.accountSecurityLabelEmail, value: data.emailMasked),
                  _InfoRow(
                    label: l10n.accountSecurityLabelPasswordUpdatedAt,
                    value: DateFormat('yyyy-MM-dd').format(data.passwordUpdatedAt),
                  ),
                  _InfoRow(
                    label: l10n.accountSecurityLabelMfa,
                    value: data.mfaEnabled
                        ? l10n.accountSecurityMfaEnabled
                        : l10n.accountSecurityMfaDisabled,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: l10n.accountSecuritySectionRecentDevices,
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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
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
              child: Text(
                l10n.accountSecurityCurrentDevice,
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
