import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient({required this.baseUrl});

  final String baseUrl;
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
    final Uri uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: queryParameters?.isEmpty ?? true
          ? null
          : queryParameters,
    );

    final Map<String, String> defaultHeaders = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    bool retried = false;
    while (true) {
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

      if (response.statusCode >= 400) {
        final String message = decoded is Map<String, dynamic>
            ? (decoded['message']?.toString() ??
                  decoded['detail']?.toString() ??
                  'Request failed')
            : 'Request failed';
        throw ApiException(message, statusCode: response.statusCode);
      }

      if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
        return decoded['data'];
      }

      return decoded;
    }
  }
}
