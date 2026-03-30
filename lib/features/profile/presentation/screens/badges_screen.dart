import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/profile/domain/models/badge_item.dart';
import 'package:my_first_app/features/profile/presentation/providers/profile_provider.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<ProfileProvider>().loadBadges();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profile = context.watch<ProfileProvider>();
    final List<BadgeItem> badges = profile.badges;

    return Scaffold(
      appBar: AppBar(title: const Text('我的勋章')),
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
              badges.isEmpty
                  ? '勋章数据会从后端个人中心接口加载。'
                  : '当前已同步 ${badges.length} 枚勋章，记录你在协作中的阶段成果。',
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (profile.badgesLoading)
            const Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(),
            ))
          else if (profile.badgesError != null)
            _buildMessageCard(profile.badgesError!)
          else if (badges.isEmpty)
            _buildMessageCard('暂无勋章数据')
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: badges.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (BuildContext context, int index) {
                return _BadgeCard(badge: badges[index]);
              },
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

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.badge});

  final BadgeItem badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.brandBlue.withAlpha(14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.workspace_premium_outlined,
              color: AppColors.brandBlue,
            ),
          ),
          const Spacer(),
          Text(
            badge.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            badge.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            DateFormat('yyyy-MM-dd').format(badge.earnedAt),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
