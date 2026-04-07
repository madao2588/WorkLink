import 'dart:convert';

import 'package:http/http.dart' as http;

String resolveApiErrorMessage({
  required String path,
  required int statusCode,
  required dynamic decoded,
  Object? requestBody,
}) {
  if (_isWorkLinkLoginBackendMismatch(
    path: path,
    statusCode: statusCode,
    decoded: decoded,
    requestBody: requestBody,
  )) {
    return '当前连接的后端不是 WorkLink，请检查 WORKLINK_API_BASE_URL 或后端端口。';
  }

  if (decoded is Map<String, dynamic>) {
    return decoded['message']?.toString() ??
        decoded['detail']?.toString() ??
        'Request failed';
  }

  return 'Request failed';
}

bool _isWorkLinkLoginBackendMismatch({
  required String path,
  required int statusCode,
  required dynamic decoded,
  Object? requestBody,
}) {
  if (path != '/auth/login' || statusCode != 422) {
    return false;
  }
  if (requestBody is! Map<String, dynamic> || !requestBody.containsKey('loginId')) {
    return false;
  }
  if (decoded is! Map<String, dynamic>) {
    return false;
  }

  final dynamic errors = decoded['data'];
  if (errors is! List) {
    return false;
  }

  for (final dynamic error in errors) {
    if (error is! Map<String, dynamic>) {
      continue;
    }

    final dynamic loc = error['loc'];
    if (loc is List &&
        loc.length >= 2 &&
        loc[0] == 'body' &&
        loc[1] == 'username') {
      return true;
    }
  }

  return false;
}

String? resolveWorkLinkFallbackBaseUrl({
  required String currentBaseUrl,
  required String path,
  required int statusCode,
  required dynamic decoded,
  Object? requestBody,
}) {
  if (!_isWorkLinkLoginBackendMismatch(
    path: path,
    statusCode: statusCode,
    decoded: decoded,
    requestBody: requestBody,
  )) {
    return null;
  }

  final Uri? currentUri = Uri.tryParse(currentBaseUrl);
  if (currentUri == null || !currentUri.hasScheme || currentUri.host.isEmpty) {
    return null;
  }
  if (currentUri.host != '127.0.0.1' && currentUri.host != 'localhost') {
    return null;
  }

  final int currentPort = currentUri.hasPort ? currentUri.port : 80;
  final int? fallbackPort = switch (currentPort) {
    8000 => 8001,
    8001 => 8000,
    _ => null,
  };
  if (fallbackPort == null) {
    return null;
  }

  return currentUri.replace(port: fallbackPort).toString();
}

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient({required String baseUrl}) : _baseUrl = baseUrl;

  String _baseUrl;
  String? Function()? _tokenProvider;
  Future<bool> Function()? _refreshHandler;

  void bindTokenProvider(String? Function() provider) {
    _tokenProvider = provider;
  }

  void bindRefreshHandler(Future<bool> Function() handler) {
    _refreshHandler = handler;
  }

  Future<dynamic> get(
    String path, {
    Map<String, String>? queryParameters,
    bool authenticated = true,
  }) {
    return _send(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
      authenticated: authenticated,
    );
  }

  Future<dynamic> post(String path, {Object? body, bool authenticated = true}) {
    return _send(
      method: 'POST',
      path: path,
      body: body,
      authenticated: authenticated,
    );
  }

  Future<dynamic> put(String path, {Object? body, bool authenticated = true}) {
    return _send(
      method: 'PUT',
      path: path,
      body: body,
      authenticated: authenticated,
    );
  }

  Future<dynamic> patch(
    String path, {
    Object? body,
    bool authenticated = true,
  }) {
    return _send(
      method: 'PATCH',
      path: path,
      body: body,
      authenticated: authenticated,
    );
  }

  Future<dynamic> _send({
    required String method,
    required String path,
    Map<String, String>? queryParameters,
    Object? body,
    bool authenticated = true,
  }) async {
    final Map<String, String> defaultHeaders = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    bool retried = false;
    bool switchedBaseUrl = false;
    while (true) {
      final Uri uri = Uri.parse('$_baseUrl$path').replace(
        queryParameters: queryParameters?.isEmpty ?? true
            ? null
            : queryParameters,
      );

      final Map<String, String> headers = Map<String, String>.from(
        defaultHeaders,
      );
      if (authenticated) {
        final String? token = _tokenProvider?.call();
        if (token == null || token.isEmpty) {
          throw ApiException('Missing access token');
        }
        headers['Authorization'] = 'Bearer $token';
      }

      late final http.Response response;
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: body == null ? null : jsonEncode(body),
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers,
            body: body == null ? null : jsonEncode(body),
          );
          break;
        case 'PATCH':
          response = await http.patch(
            uri,
            headers: headers,
            body: body == null ? null : jsonEncode(body),
          );
          break;
        default:
          throw ApiException('Unsupported HTTP method: $method');
      }

      if (response.statusCode == 401 &&
          authenticated &&
          !retried &&
          _refreshHandler != null) {
        retried = true;
        final bool refreshed = await _refreshHandler!();
        if (refreshed) {
          continue;
        }
      }

      final dynamic decoded = response.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body);

      final String? fallbackBaseUrl = switchedBaseUrl
          ? null
          : resolveWorkLinkFallbackBaseUrl(
              currentBaseUrl: _baseUrl,
              path: path,
              statusCode: response.statusCode,
              decoded: decoded,
              requestBody: body,
            );
      if (fallbackBaseUrl != null) {
        _baseUrl = fallbackBaseUrl;
        switchedBaseUrl = true;
        retried = false;
        continue;
      }

      if (response.statusCode >= 400) {
        final String message = resolveApiErrorMessage(
          path: path,
          statusCode: response.statusCode,
          decoded: decoded,
          requestBody: body,
        );
        throw ApiException(message, statusCode: response.statusCode);
      }

      if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
        return decoded['data'];
      }

      return decoded;
    }
  }
}
