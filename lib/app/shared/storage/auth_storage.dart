import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalAuthStorage {
  LocalAuthStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const String _accessTokenKey = 'worklink_access_token';
  static const String _refreshTokenKey = 'worklink_refresh_token';

  final FlutterSecureStorage _storage;

  Future<void> initialize() async {
    // FlutterSecureStorage may require platform binding initialization.
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> readAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  Future<String?> readRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
