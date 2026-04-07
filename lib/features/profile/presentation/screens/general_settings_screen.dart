import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/app/theme/theme_mode_controller.dart';
import 'package:my_first_app/features/profile/domain/models/general_settings_data.dart';
import 'package:my_first_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:my_first_app/l10n/app_localizations.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ProfileProvider profile = context.watch<ProfileProvider>();
    final GeneralSettingsData? settings = profile.settings;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.generalSettingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: <Widget>[
          if (profile.settingsLoading)
            const Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(),
            ))
          else if (profile.settingsError != null)
            _buildMessageCard(profile.settingsError!)
          else if (settings == null)
            _buildMessageCard(l10n.generalSettingsEmpty)
          else ...<Widget>[
            _SettingsCard(
              title: l10n.generalSettingsSectionNotifications,
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    value: settings.notificationsEnabled,
                    onChanged: (bool value) => _updateSettings(
                      settings.copyWith(notificationsEnabled: value),
                    ),
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppColors.brandBlue,
                    title: Text(l10n.generalSettingsPushTitle),
                    subtitle: Text(l10n.generalSettingsPushSubtitle),
                  ),
                  SwitchListTile(
                    value: settings.soundEnabled,
                    onChanged: (bool value) => _updateSettings(
                      settings.copyWith(soundEnabled: value),
                    ),
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppColors.brandBlue,
                    title: Text(l10n.generalSettingsSoundTitle),
                    subtitle: Text(l10n.generalSettingsSoundSubtitle),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SettingsCard(
              title: l10n.generalSettingsSectionDisplay,
              child: Column(
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.generalSettingsLanguageTitle),
                    subtitle: Text(l10n.generalSettingsLanguageSubtitle),
                    trailing: DropdownButton<String>(
                      value: settings.language,
                      underline: const SizedBox.shrink(),
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: 'zh-CN',
                          child: Text(l10n.generalSettingsLanguageZhHans),
                        ),
                        const DropdownMenuItem<String>(
                          value: 'en-US',
                          child: Text('English'),
                        ),
                      ],
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        _updateSettings(settings.copyWith(language: value));
                      },
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.generalSettingsThemeTitle),
                    subtitle: Text(l10n.generalSettingsThemeSubtitle),
                    trailing: DropdownButton<String>(
                      value: settings.themeMode,
                      underline: const SizedBox.shrink(),
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: 'light',
                          child: Text(l10n.generalSettingsThemeLight),
                        ),
                        DropdownMenuItem<String>(
                          value: 'dark',
                          child: Text(l10n.generalSettingsThemeDark),
                        ),
                      ],
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        _updateSettings(settings.copyWith(themeMode: value));
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SettingsCard(
              title: l10n.generalSettingsSectionOther,
              child: Column(
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.cleaning_services_outlined,
                      color: AppColors.brandBlue,
                    ),
                    title: Text(l10n.generalSettingsCacheSizeTitle),
                    subtitle: Text(settings.cacheSize),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.info,
                    ),
                    title: Text(l10n.generalSettingsVersionTitle),
                    subtitle: Text(l10n.generalSettingsVersionValue),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _updateSettings(GeneralSettingsData nextSettings) async {
    context.read<AppThemeModeController>().setThemeModeFromSetting(
      nextSettings.themeMode,
    );
    await context.read<ProfileProvider>().updateSettings(nextSettings);
  }

  Future<void> _loadSettings() async {
    final ProfileProvider profileProvider = context.read<ProfileProvider>();
    await profileProvider.loadSettings();
    if (!mounted) {
      return;
    }
    final GeneralSettingsData? settings = profileProvider.settings;
    if (settings == null) {
      return;
    }
    context.read<AppThemeModeController>().setThemeModeFromSetting(
      settings.themeMode,
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

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
