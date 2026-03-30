import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/profile/presentation/providers/profile_provider.dart';

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
    final ProfileProvider profile = context.watch<ProfileProvider>();
    const List<_FeedbackOption> options = <_FeedbackOption>[
      _FeedbackOption(value: 'feature', label: '功能建议'),
      _FeedbackOption(value: 'ui', label: '界面体验'),
      _FeedbackOption(value: 'bug', label: 'Bug 反馈'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('帮助与反馈')),
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
            child: const Text(
              '这页现在已经能把反馈真实提交到后端接口，方便你后续接工单、邮件或后台管理。',
              style: TextStyle(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _FaqCard(
            title: '为什么消息没有刷新？',
            answer: '请先确认本地后端已启动，当前消息和个人中心已经开始依赖真实接口。',
          ),
          const _FaqCard(
            title: '审批提交后在哪里查看？',
            answer: '可以在“我的审批”或工作台入口进入审批中心查看最新记录。',
          ),
          const _FaqCard(
            title: '登录失败怎么办？',
            answer: '先确认后端服务正常运行，再检查演示账号 zhangsan / 123456 是否可用。',
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
                const Text(
                  '提交反馈',
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
                  decoration: const InputDecoration(
                    hintText: '描述你的问题或建议，提交后会通过后端反馈接口保存。',
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
                      profile.feedbackSubmitting ? '提交中...' : '提交反馈',
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
    final String text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先填写反馈内容')),
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
        const SnackBar(content: Text('反馈已提交到后端')),
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
