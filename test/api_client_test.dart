import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/app/shared/network/api_client.dart';

void main() {
  test('translates login schema mismatch into backend mismatch guidance', () {
    final String message = resolveApiErrorMessage(
      path: '/auth/login',
      statusCode: 422,
      requestBody: <String, dynamic>{
        'loginId': 'zhangsan',
        'password': '123456',
      },
      decoded: <String, dynamic>{
        'code': 422,
        'message': '请求参数校验失败',
        'data': <Map<String, dynamic>>[
          <String, dynamic>{
            'loc': <String>['body', 'username'],
            'msg': 'Field required',
          },
        ],
      },
    );

    expect(message, '当前连接的后端不是 WorkLink，请检查 WORKLINK_API_BASE_URL 或后端端口。');
  });

  test('keeps backend message for regular api failures', () {
    final String message = resolveApiErrorMessage(
      path: '/auth/login',
      statusCode: 401,
      requestBody: <String, dynamic>{
        'loginId': 'zhangsan',
        'password': 'wrong-password',
      },
      decoded: <String, dynamic>{
        'message': 'Invalid credentials',
      },
    );

    expect(message, 'Invalid credentials');
  });

  test('resolves local fallback port for login backend mismatch', () {
    final String? fallbackBaseUrl = resolveWorkLinkFallbackBaseUrl(
      currentBaseUrl: 'http://127.0.0.1:8000/api/v1',
      path: '/auth/login',
      statusCode: 422,
      requestBody: <String, dynamic>{
        'loginId': 'zhangsan',
        'password': '123456',
      },
      decoded: <String, dynamic>{
        'data': <Map<String, dynamic>>[
          <String, dynamic>{
            'loc': <String>['body', 'username'],
          },
        ],
      },
    );

    expect(fallbackBaseUrl, 'http://127.0.0.1:8001/api/v1');
  });
}
