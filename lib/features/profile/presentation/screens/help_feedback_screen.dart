import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

class HelpFeedbackScreen extends StatefulWidget {
  const HelpFeedbackScreen({super.key});

  @override
  State<HelpFeedbackScreen> createState() => _HelpFeedbackScreenState();
}

class _HelpFeedbackScreenState extends State<HelpFeedbackScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedType = 'feature';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ProfileProvider profile = context.watch<ProfileProvider>();
    final List<_FeedbackOption> options = <_FeedbackOption>[
      _FeedbackOption(value: 'feature', label: l10n.helpFeedbackCategoryFeature),
      _FeedbackOption(value: 'ui', label: l10n.helpFeedbackCategoryUi),
      _FeedbackOption(value: 'bug', label: l10n.helpFeedbackCategoryBug),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.helpFeedbackTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              l10n.helpFeedbackIntro,
              style: TextStyle(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _FaqCard(
            title: l10n.helpFeedbackFaqMessagesTitle,
            answer: l10n.helpFeedbackFaqMessagesAnswer,
          ),
          _FaqCard(
            title: l10n.helpFeedbackFaqApprovalTitle,
            answer: l10n.helpFeedbackFaqApprovalAnswer,
          ),
          _FaqCard(
            title: l10n.helpFeedbackFaqLoginTitle,
            answer: l10n.helpFeedbackFaqLoginAnswer,
          ),
          const SizedBox(height: 18),
          Container(
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
                  l10n.helpFeedbackSubmitSectionTitle,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: options.map((option) {
                    final bool selected = _selectedType == option.value;
                    return ChoiceChip(
                      label: Text(option.label),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedType = option.value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: l10n.helpFeedbackInputHint,
                    alignLabelWithHint: true,
                  ),
                ),
                if (profile.feedbackError != null) ...<Widget>[
                  const SizedBox(height: 12),
                  Text(
                    profile.feedbackError!,
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: profile.feedbackSubmitting ? null : _submit,
                    child: Text(
                      profile.feedbackSubmitting
                          ? l10n.helpFeedbackSubmitting
                          : l10n.helpFeedbackSubmitButton,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.helpFeedbackEmptyContent)),
      );
      return;
    }

    final bool success = await context.read<ProfileProvider>().submitFeedback(
      category: _selectedType,
      content: text,
    );
    if (!mounted) {
      return;
    }
    if (success) {
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.helpFeedbackSubmitSuccess)),
      );
    }
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.title, required this.answer});

  final String title;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        children: <Widget>[
          Text(
            answer,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackOption {
  const _FeedbackOption({required this.value, required this.label});

  final String value;
  final String label;
}
