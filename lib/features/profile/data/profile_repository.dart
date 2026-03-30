import 'package:my_first_app/app/shared/network/api_client.dart';
import 'package:my_first_app/app/shared/models/user_model.dart';
import 'package:my_first_app/features/profile/domain/models/account_security_data.dart';
import 'package:my_first_app/features/profile/domain/models/badge_item.dart';
import 'package:my_first_app/features/profile/domain/models/general_settings_data.dart';
import 'package:my_first_app/features/profile/domain/models/profile_overview.dart';
import 'package:my_first_app/features/profile/domain/models/salary_slip_item.dart';

class ProfileRepository {
  ProfileRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<ProfileOverview> fetchOverview() async {
    final dynamic data = await _apiClient.get('/profile/overview');
    final Map<String, dynamic> user =
        data['user'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> attendance =
        data['attendance'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> approval =
        data['approval'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> chat =
        data['chat'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return ProfileOverview(
      user: UserModel(
        id: user['id'] as String? ?? '',
        name: user['name'] as String? ?? '--',
        avatar: user['avatar'] as String? ?? '--',
        department: user['department'] as String? ?? '--',
        isOnline: user['isOnline'] as bool? ?? false,
      ),
      attendanceStatus: attendance['status'] as String? ?? 'NOT_CHECKED_IN',
      hasCheckedIn: attendance['hasCheckedIn'] as bool? ?? false,
      checkInTime: attendance['checkInTime'] == null
          ? null
          : DateTime.parse(attendance['checkInTime'] as String).toLocal(),
      pendingApprovalCount: approval['pendingCount'] as int? ?? 0,
      totalMessageCount: chat['totalMessageCount'] as int? ?? 0,
      unreadMessageCount: chat['unreadCount'] as int? ?? 0,
    );
  }

  Future<List<SalarySlipItem>> fetchSalarySlips() async {
    final dynamic data = await _apiClient.get('/profile/salary-slips');
    final List<dynamic> items = data as List<dynamic>? ?? <dynamic>[];
    return items.map((dynamic item) {
      final Map<String, dynamic> json = item as Map<String, dynamic>;
      return SalarySlipItem(
        id: json['salarySlipId'] as String,
        month: json['month'] as String,
        netAmount: (json['netAmount'] as num).toDouble(),
        grossAmount: (json['grossAmount'] as num).toDouble(),
        status: json['status'] as String,
        issuedAt: DateTime.parse(json['issuedAt'] as String).toLocal(),
      );
    }).toList();
  }

  Future<List<BadgeItem>> fetchBadges() async {
    final dynamic data = await _apiClient.get('/profile/badges');
    final List<dynamic> items = data as List<dynamic>? ?? <dynamic>[];
    return items.map((dynamic item) {
      final Map<String, dynamic> json = item as Map<String, dynamic>;
      return BadgeItem(
        id: json['badgeId'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        icon: json['icon'] as String? ?? 'star',
        earnedAt: DateTime.parse(json['earnedAt'] as String).toLocal(),
      );
    }).toList();
  }

  Future<AccountSecurityData> fetchAccountSecurity() async {
    final dynamic data = await _apiClient.get('/profile/account-security');
    final List<dynamic> devices =
        data['devices'] as List<dynamic>? ?? <dynamic>[];
    return AccountSecurityData(
      mobileMasked: data['mobileMasked'] as String? ?? '--',
      emailMasked: data['emailMasked'] as String? ?? '--',
      passwordUpdatedAt: DateTime.parse(
        data['passwordUpdatedAt'] as String,
      ).toLocal(),
      devices: devices.map((dynamic item) {
        final Map<String, dynamic> json = item as Map<String, dynamic>;
        return LoginDeviceItem(
          id: json['deviceId'] as String,
          name: json['deviceName'] as String,
          platform: json['platform'] as String? ?? 'unknown',
          lastLoginAt: DateTime.parse(json['lastLoginAt'] as String).toLocal(),
          isCurrent: json['current'] as bool? ?? false,
        );
      }).toList(),
      mfaEnabled: data['mfaEnabled'] as bool? ?? false,
    );
  }

  Future<GeneralSettingsData> fetchSettings() async {
    final dynamic data = await _apiClient.get('/profile/settings');
    return GeneralSettingsData(
      notificationsEnabled: data['notificationsEnabled'] as bool? ?? true,
      soundEnabled: data['soundEnabled'] as bool? ?? true,
      language: data['language'] as String? ?? 'zh-CN',
      themeMode: data['themeMode'] as String? ?? 'light',
      cacheSize: data['cacheSize'] as String? ?? '--',
    );
  }

  Future<GeneralSettingsData> updateSettings(
    GeneralSettingsData settings,
  ) async {
    final dynamic data = await _apiClient.put(
      '/profile/settings',
      body: <String, dynamic>{
        'notificationsEnabled': settings.notificationsEnabled,
        'soundEnabled': settings.soundEnabled,
        'language': settings.language,
        'themeMode': settings.themeMode,
      },
    );
    return GeneralSettingsData(
      notificationsEnabled: data['notificationsEnabled'] as bool? ?? true,
      soundEnabled: data['soundEnabled'] as bool? ?? true,
      language: data['language'] as String? ?? 'zh-CN',
      themeMode: data['themeMode'] as String? ?? 'light',
      cacheSize: data['cacheSize'] as String? ?? '--',
    );
  }

  Future<void> submitFeedback({
    required String category,
    required String content,
  }) async {
    await _apiClient.post(
      '/profile/feedback',
      body: <String, dynamic>{
        'category': category,
        'content': content,
        'attachments': <dynamic>[],
      },
    );
  }
}
