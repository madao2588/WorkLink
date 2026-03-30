import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/features/profile/domain/models/general_settings_data.dart';
import 'package:my_first_app/features/profile/presentation/providers/profile_provider.dart';

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
      context.read<ProfileProvider>().loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profile = context.watch<ProfileProvider>();
    final GeneralSettingsData? settings = profile.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('通用设置')),
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
            _buildMessageCard('暂无设置数据')
          else ...<Widget>[
            _SettingsCard(
              title: '通知偏好',
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    value: settings.notificationsEnabled,
                    onChanged: (bool value) => _updateSettings(
                      settings.copyWith(notificationsEnabled: value),
                    ),
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppColors.brandBlue,
                    title: const Text('消息推送'),
                    subtitle: const Text('收到聊天或审批时即时提醒'),
                  ),
                  SwitchListTile(
                    value: settings.soundEnabled,
                    onChanged: (bool value) => _updateSettings(
                      settings.copyWith(soundEnabled: value),
                    ),
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppColors.brandBlue,
                    title: const Text('声音提醒'),
                    subtitle: const Text('允许声音反馈和系统提示'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SettingsCard(
              title: '显示与偏好',
              child: Column(
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('语言'),
                    subtitle: const Text('设置界面显示语言'),
                    trailing: DropdownButton<String>(
                      value: settings.language,
                      underline: const SizedBox.shrink(),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: 'zh-CN',
                          child: Text('简体中文'),
                        ),
                        DropdownMenuItem<String>(
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
                    title: const Text('主题'),
                    subtitle: const Text('后端已保存当前主题模式'),
                    trailing: DropdownButton<String>(
                      value: settings.themeMode,
                      underline: const SizedBox.shrink(),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: 'light',
                          child: Text('Light'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'dark',
                          child: Text('Dark'),
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
              title: '其他',
              child: Column(
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.cleaning_services_outlined,
                      color: AppColors.brandBlue,
                    ),
                    title: const Text('缓存大小'),
                    subtitle: Text(settings.cacheSize),
                  ),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.info,
                    ),
                    title: Text('当前版本'),
                    subtitle: Text('WorkLink 1.0.0'),
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
    await context.read<ProfileProvider>().updateSettings(nextSettings);
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
