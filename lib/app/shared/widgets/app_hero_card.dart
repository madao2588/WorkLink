import 'package:flutter/material.dart';

import 'package:my_first_app/app/theme/app_theme.dart';

class AppHeroCard extends StatelessWidget {
  const AppHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.badgeText,
    this.leading,
    this.trailing,
    this.child,
    this.padding = const EdgeInsets.all(24),
  });

  final String title;
  final String subtitle;
  final String? badgeText;
  final Widget? leading;
  final Widget? trailing;
  final Widget? child;
  final EdgeInsetsGeometry padding;

  static const BorderRadius _radius = BorderRadius.all(Radius.circular(32));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: AppThemePalette.heroGradient(context),
        borderRadius: _radius,
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
              ...?leading == null ? null : <Widget>[leading!, const Spacer()],
              ...?badgeText == null
                  ? null
                  : <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(20),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badgeText!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
              if (trailing != null) ...<Widget>[
                if (badgeText != null) const SizedBox(width: 12),
                trailing!,
              ],
            ],
          ),
          const SizedBox(height: 22),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withAlpha(220),
              height: 1.6,
            ),
          ),
          if (child != null) ...<Widget>[
            const SizedBox(height: 20),
            child!,
          ],
        ],
      ),
    );
  }
}

