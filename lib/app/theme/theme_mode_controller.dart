import 'package:flutter/material.dart';

class AppThemeModeController with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleThemeMode() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setThemeMode(ThemeMode nextMode) {
    if (_themeMode == nextMode) {
      return;
    }
    _themeMode = nextMode;
    notifyListeners();
  }

  void setThemeModeFromSetting(String themeMode) {
    switch (themeMode) {
      case 'dark':
        setThemeMode(ThemeMode.dark);
        return;
      case 'light':
      default:
        setThemeMode(ThemeMode.light);
    }
  }
}
