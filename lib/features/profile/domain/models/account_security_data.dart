class LoginDeviceItem {
  const LoginDeviceItem({
    required this.id,
    required this.name,
    required this.platform,
    required this.lastLoginAt,
    required this.isCurrent,
  });

  final String id;
  final String name;
  final String platform;
  final DateTime lastLoginAt;
  final bool isCurrent;
}

class AccountSecurityData {
  const AccountSecurityData({
    required this.mobileMasked,
    required this.emailMasked,
    required this.passwordUpdatedAt,
    required this.devices,
    required this.mfaEnabled,
  });

  final String mobileMasked;
  final String emailMasked;
  final DateTime passwordUpdatedAt;
  final List<LoginDeviceItem> devices;
  final bool mfaEnabled;
}
