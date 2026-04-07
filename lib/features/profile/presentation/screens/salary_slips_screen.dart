import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/profile/domain/models/salary_slip_item.dart';
import 'package:my_first_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

class SalarySlipsScreen extends StatefulWidget {
  const SalarySlipsScreen({super.key});

  @override
  State<SalarySlipsScreen> createState() => _SalarySlipsScreenState();
}

class _SalarySlipsScreenState extends State<SalarySlipsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<ProfileProvider>().loadSalarySlips();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ProfileProvider profile = context.watch<ProfileProvider>();
    final List<SalarySlipItem> slips = profile.salarySlips;
    final SalarySlipItem? latest = slips.isEmpty ? null : slips.first;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.salarySlipsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: <Widget>[
          _buildSummaryCard(latest, l10n),
          const SizedBox(height: 20),
          Text(
            l10n.salarySlipsRecentTitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          if (profile.salarySlipsLoading)
            const Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(),
            ))
          else if (profile.salarySlipsError != null)
            _buildMessageCard(profile.salarySlipsError!)
          else if (slips.isEmpty)
            _buildMessageCard(l10n.salarySlipsEmpty)
          else
            ...slips.map((SalarySlipItem slip) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _SalarySlipCard(slip: slip),
                )),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(SalarySlipItem? latest, AppLocalizations l10n) {
    final String title = latest == null ? '--' : '¥${latest.netAmount.toStringAsFixed(2)}';
    final String subtitle = latest == null
        ? l10n.salarySlipsSummaryWaiting
        : l10n.salarySlipsSummaryLatest(latest.month);

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.account_balance_wallet_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                l10n.salarySlipsSummaryCurrentNet,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              height: 1.5,
            ),
          ),
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

class _SalarySlipCard extends StatelessWidget {
  const _SalarySlipCard({required this.slip});

  final SalarySlipItem slip;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                slip.month,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  slip.status,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SalaryDataRow(
            label: l10n.salarySlipsNetPayLabel,
            value: '¥${slip.netAmount.toStringAsFixed(2)}',
          ),
          _SalaryDataRow(
            label: l10n.salarySlipsGrossPayLabel,
            value: '¥${slip.grossAmount.toStringAsFixed(2)}',
          ),
          _SalaryDataRow(
            label: l10n.salarySlipsIssuedAtLabel,
            value: DateFormat('yyyy-MM-dd').format(slip.issuedAt),
          ),
        ],
      ),
    );
  }
}

class _SalaryDataRow extends StatelessWidget {
  const _SalaryDataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
