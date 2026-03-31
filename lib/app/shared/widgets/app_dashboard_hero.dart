import 'package:flutter/material.dart';

import 'package:my_first_app/app/shared/widgets/app_hero_card.dart';

class AppDashboardHero extends StatelessWidget {
  const AppDashboardHero({
    super.key,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.icon,
    required this.stats,
  });

  final String title;
  final String subtitle;
  final String badgeText;
  final IconData icon;
  final List<AppDashboardHeroStat> stats;

  @override
  Widget build(BuildContext context) {
    return AppHeroCard(
      title: title,
      subtitle: subtitle,
      badgeText: badgeText,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(24),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withAlpha(28)),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final int columns = constraints.maxWidth < 360
              ? 1
              : constraints.maxWidth < 560
              ? 2
              : stats.length;
          final double cardWidth = columns == 1
              ? constraints.maxWidth
              : (constraints.maxWidth - (columns - 1) * 10) / columns;

          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final AppDashboardHeroStat stat in stats)
                SizedBox(
                  width: cardWidth,
                  child: _HeroStatCard(stat: stat),
                ),
            ],
          );
        },
      ),
    );
  }
}

class AppDashboardHeroStat {
  const AppDashboardHeroStat({required this.label, required this.value});

  final String label;
  final String value;
}

class _HeroStatCard extends StatelessWidget {
  const _HeroStatCard({required this.stat});

  final AppDashboardHeroStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withAlpha(220),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
