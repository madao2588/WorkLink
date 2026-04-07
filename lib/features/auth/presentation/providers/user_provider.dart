import 'package:flutter/material.dart';

import 'package:my_first_app/app/shared/models/user_model.dart';
import 'package:my_first_app/app/shared/network/api_client.dart';
import 'package:my_first_app/app/shared/storage/auth_storage.dart';
import 'package:my_first_app/features/auth/data/auth_repository.dart';

class UserProvider with ChangeNotifier {
  UserProvider({
    required AuthRepository authRepository,
    required ApiClient apiClient,
    required LocalAuthStorage authStorage,
  }) : _authRepository = authRepository,
       _authStorage = authStorage {
    apiClient.bindTokenProvider(() => _accessToken);
    apiClient.bindRefreshHandler(_refreshSession);
    Future.microtask(_restoreSession);
  }

  final AuthRepository _authRepository;
  final LocalAuthStorage _authStorage;

  UserModel? _currentUser;
  String? _accessToken;
  String? _refreshToken;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null && _accessToken != null;

  Future<void> _restoreSession() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String? accessToken = await _authStorage.readAccessToken();
      final String? refreshToken = await _authStorage.readRefreshToken();

      if (accessToken != null && refreshToken != null) {
        _accessToken = accessToken;
        _refreshToken = refreshToken;
        notifyListeners();

        try {
          final UserModel restoredUser = await _authRepository.getCurrentUser();
          _currentUser = restoredUser.copyWith(
            loginId: restoredUser.loginId ?? _currentUser?.loginId,
            role: restoredUser.role ?? _currentUser?.role,
            permissions: restoredUser.permissions.isEmpty
                ? _currentUser?.permissions
                : restoredUser.permissions,
          );
        } on ApiException {
          final bool refreshed = await _refreshSession();
          if (refreshed) {
            final UserModel restoredUser = await _authRepository.getCurrentUser();
            _currentUser = restoredUser.copyWith(
              loginId: restoredUser.loginId ?? _currentUser?.loginId,
              role: restoredUser.role ?? _currentUser?.role,
              permissions: restoredUser.permissions.isEmpty
                  ? _currentUser?.permissions
                  : restoredUser.permissions,
            );
          } else {
            await logout();
          }
        }
      }
    } catch (e) {
      // Web refresh 过程中，secure storage 读写可能会抛异常。
      // 为避免白屏，出错后降级到未登录状态。
      _currentUser = null;
      _accessToken = null;
      _refreshToken = null;
      _errorMessage = e.toString();
      try {
        await _authStorage.clearTokens();
      } catch (_) {
        // ignore
      }
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _refreshSession() async {
    if (_refreshToken == null || _refreshToken!.isEmpty) {
      return false;
    }

    try {
      final AuthRefreshResult result = await _authRepository.refreshToken(
        refreshToken: _refreshToken!,
      );
      _accessToken = result.accessToken;
      _refreshToken = result.refreshToken;
      await _authStorage.saveTokens(
        accessToken: _accessToken!,
        refreshToken: _refreshToken!,
      );
      notifyListeners();
      return true;
    } on ApiException {
      await logout();
      return false;
    }
  }

  Future<bool> login({
    required String loginId,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final AuthLoginResult result = await _authRepository.login(
        loginId: loginId,
        password: password,
      );
      _currentUser = result.user;
      _accessToken = result.accessToken;
      _refreshToken = result.refreshToken;
      await _authStorage.saveTokens(
        accessToken: _accessToken!,
        refreshToken: _refreshToken!,
      );
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final String? token = _refreshToken;
    if (token != null && token.isNotEmpty) {
      try {
        await _authRepository.logout(token);
      } on ApiException {
        // Keep local logout resilient for demo mode.
      }
    }

    _currentUser = null;
    _accessToken = null;
    _refreshToken = null;
    _errorMessage = null;
    await _authStorage.clearTokens();
    notifyListeners();
  }
}
