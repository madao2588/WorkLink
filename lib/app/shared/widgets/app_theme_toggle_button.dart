import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/theme/theme_mode_controller.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

class AppThemeToggleButton extends StatelessWidget {
  const AppThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeModeController controller =
        context.watch<AppThemeModeController>();
    final bool darkMode = controller.isDarkMode;
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return IconButton(
      tooltip: darkMode
          ? l10n.themeToggleSwitchToLight
          : l10n.themeToggleSwitchToDark,
      onPressed: controller.toggleThemeMode,
      icon: Icon(
        darkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
      ),
    );
  }
}

class AppThemeCornerButton extends StatelessWidget {
  const AppThemeCornerButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeModeController controller =
        context.watch<AppThemeModeController>();
    final bool darkMode = controller.isDarkMode;
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String semanticLabel = darkMode
        ? l10n.themeToggleSwitchToLight
        : l10n.themeToggleSwitchToDark;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: controller.toggleThemeMode,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: darkMode
                ? const Color(0xFF202734).withAlpha(242)
                : Colors.white.withAlpha(242),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: darkMode
                  ? const Color(0xFF3C4858)
                  : AppThemeTogglePalette.lightBorder,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withAlpha(darkMode ? 28 : 16),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  darkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  size: 18,
                  color: darkMode
                      ? const Color(0xFFE7EDF7)
                      : const Color(0xFF174AE3),
                ),
                const SizedBox(width: 6),
                Text(
                  darkMode
                      ? l10n.themeToggleLabelLight
                      : l10n.themeToggleLabelDark,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: darkMode
                        ? const Color(0xFFE8EDF5)
                        : const Color(0xFF172033),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppThemeTogglePalette {
  static const Color lightBorder = Color(0xFFD7E0F0);
}
