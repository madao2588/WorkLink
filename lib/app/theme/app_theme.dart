import 'package:flutter/material.dart';

class AppColors {
  static const Color brandBlue = Color(0xFF1456F0);
  static const Color brandSky = Color(0xFF4DA3FF);
  static const Color accentCyan = Color(0xFF67E8F9);
  static const Color background = Color(0xFFF5F7FB);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF172033);
  static const Color textSecondary = Color(0xFF667085);
  static const Color textHint = Color(0xFF98A2B3);
  static const Color border = Color(0xFFE4E7EC);
  static const Color success = Color(0xFF12B76A);
  static const Color warning = Color(0xFFF79009);
  static const Color danger = Color(0xFFF04438);
  static const Color info = Color(0xFF36BFFA);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [brandBlue, brandSky],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F3CC9), Color(0xFF2A6FF6), Color(0xFF72B6FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.brandBlue,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.brandBlue,
      secondary: AppColors.brandSky,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      outline: AppColors.border,
    );

    final ThemeData base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shadowColor: Colors.black.withAlpha(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: AppColors.textHint),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIconColor: AppColors.textSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.brandBlue, width: 1.6),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.brandBlue.withAlpha(90),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        height: 76,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? AppColors.brandBlue
                : AppColors.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.brandBlue
                : AppColors.textSecondary,
          );
        }),
        indicatorColor: AppColors.brandBlue.withAlpha(22),
      ),
    );
  }

  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6F92FF),
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFF7E9FFF),
      secondary: const Color(0xFF9CB7FF),
      surface: const Color(0xFF181E27),
      onSurface: const Color(0xFFE8EDF5),
      outline: const Color(0xFF2D3643),
    );

    final ThemeData base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF11161D),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFFE8EDF5),
        displayColor: const Color(0xFFE8EDF5),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFE8EDF5),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFFE8EDF5),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF181E27),
        elevation: 0,
        shadowColor: Colors.black.withAlpha(24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFF2D3643)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2D3643),
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF141A22),
        hintStyle: const TextStyle(color: Color(0xFF7E8A9D)),
        labelStyle: const TextStyle(color: Color(0xFFA8B3C4)),
        prefixIconColor: const Color(0xFFA8B3C4),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF2D3643)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF2D3643)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF7E9FFF), width: 1.6),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5B7EE5),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF5B7EE5).withAlpha(90),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFE8EDF5),
        contentTextStyle: const TextStyle(color: Color(0xFF11161D)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF151B24),
        surfaceTintColor: Colors.transparent,
        height: 76,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? const Color(0xFF9CB7FF)
                : const Color(0xFFA8B3C4),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? const Color(0xFF9CB7FF)
                : const Color(0xFFA8B3C4),
          );
        }),
        indicatorColor: const Color(0xFF5B7EE5).withAlpha(40),
      ),
    );
  }
}

class AppThemePalette {
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color pageBackground(BuildContext context) => isDark(context)
      ? const Color(0xFF11161D)
      : AppColors.background;

  static Color surface(BuildContext context) =>
      isDark(context) ? const Color(0xFF181E27) : Colors.white;

  static Color elevatedSurface(BuildContext context) =>
      isDark(context) ? const Color(0xFF202734) : Colors.white;

  static Color mutedSurface(BuildContext context) =>
      isDark(context) ? const Color(0xFF151B24) : const Color(0xFFF6F8FC);

  static Color subtleSurface(BuildContext context) =>
      isDark(context) ? const Color(0xFF131922) : const Color(0xFFF9FBFF);

  static Color border(BuildContext context) =>
      isDark(context) ? const Color(0xFF2D3643) : AppColors.border;

  static Color strongBorder(BuildContext context) => isDark(context)
      ? const Color(0xFF3C4858)
      : const Color(0xFFD9E6FF);

  static Color textPrimary(BuildContext context) => isDark(context)
      ? const Color(0xFFE8EDF5)
      : AppColors.textPrimary;

  static Color textSecondary(BuildContext context) => isDark(context)
      ? const Color(0xFFA8B3C4)
      : AppColors.textSecondary;

  static Color textHint(BuildContext context) => isDark(context)
      ? const Color(0xFF7E8A9D)
      : AppColors.textHint;

  static Color shadow(BuildContext context) =>
      Colors.black.withAlpha(isDark(context) ? 28 : 8);

  static LinearGradient heroGradient(BuildContext context) => isDark(context)
      ? const LinearGradient(
          colors: <Color>[
            Color(0xFF16305E),
            Color(0xFF27539A),
            Color(0xFF4A84D8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : AppColors.heroGradient;

  static Color heroShadow(BuildContext context) => isDark(context)
      ? const Color(0xFF15386B).withAlpha(72)
      : AppColors.brandBlue.withAlpha(30);
}
