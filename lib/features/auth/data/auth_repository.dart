import 'package:my_first_app/app/shared/models/user_model.dart';
import 'package:my_first_app/app/shared/network/api_client.dart';

class AuthLoginResult {
  const AuthLoginResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final UserModel user;
  final String accessToken;
  final String refreshToken;
}

class AuthRefreshResult {
  const AuthRefreshResult({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;
}

class AuthRepository {
  AuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<AuthLoginResult> login({
    required String loginId,
    required String password,
  }) async {
    final dynamic data = await _apiClient.post(
      '/auth/login',
      authenticated: false,
      body: <String, dynamic>{
        'loginId': loginId,
        'password': password,
        'deviceName': 'Flutter Desktop',
        'platform': 'windows',
      },
    );

    final Map<String, dynamic> userData = data['user'] as Map<String, dynamic>;
    return AuthLoginResult(
      user: UserModel(
        id: userData['id'] as String,
        name: userData['name'] as String,
        avatar: userData['avatar'] as String,
        department: userData['department'] as String,
        loginId: userData['loginId'] as String? ?? loginId,
        departmentId: userData['departmentId'] as String?,
        position: userData['position'] as String?,
        employeeNo: userData['employeeNo'] as String?,
        email: userData['email'] as String?,
        mobileMasked: userData['mobileMasked'] as String?,
        role: userData['role'] as String?,
        permissions: (userData['permissions'] as List<dynamic>? ?? <dynamic>[])
            .whereType<String>()
            .toList(),
        isOnline: userData['isOnline'] as bool? ?? false,
      ),
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }

  Future<AuthRefreshResult> refreshToken({required String refreshToken}) async {
    final dynamic data = await _apiClient.post(
      '/auth/refresh-token',
      authenticated: false,
      body: <String, dynamic>{'refreshToken': refreshToken},
    );

    return AuthRefreshResult(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }

  Future<UserModel> getCurrentUser() async {
    final dynamic data = await _apiClient.get('/auth/me');
    return UserModel(
      id: data['id'] as String,
      name: data['name'] as String,
      avatar: data['avatar'] as String,
      department: data['department'] as String,
      loginId: data['loginId'] as String?,
      departmentId: data['departmentId'] as String?,
      position: data['position'] as String?,
      employeeNo: data['employeeNo'] as String?,
      email: data['email'] as String?,
      mobileMasked: data['mobileMasked'] as String?,
      role: data['role'] as String?,
      permissions: (data['permissions'] as List<dynamic>? ?? <dynamic>[])
          .whereType<String>()
          .toList(),
      isOnline: data['isOnline'] as bool? ?? false,
    );
  }

  Future<void> logout(String refreshToken) async {
    await _apiClient.post(
      '/auth/logout',
      authenticated: false,
      body: <String, dynamic>{'refreshToken': refreshToken},
    );
  }
}
