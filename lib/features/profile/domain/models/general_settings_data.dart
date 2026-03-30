class GeneralSettingsData {
  const GeneralSettingsData({
    required this.notificationsEnabled,
    required this.soundEnabled,
    required this.language,
    required this.themeMode,
    required this.cacheSize,
  });

  final bool notificationsEnabled;
  final bool soundEnabled;
  final String language;
  final String themeMode;
  final String cacheSize;

  GeneralSettingsData copyWith({
    bool? notificationsEnabled,
    bool? soundEnabled,
    String? language,
    String? themeMode,
    String? cacheSize,
  }) {
    return GeneralSettingsData(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      cacheSize: cacheSize ?? this.cacheSize,
    );
  }
}
