import 'package:flutter/foundation.dart';

class AppApiConfig {
  static const String _configuredBaseUrl = String.fromEnvironment(
    'WORKLINK_API_BASE_URL',
    defaultValue: '',
  );

  static String get baseUrl {
    if (_configuredBaseUrl.trim().isNotEmpty) {
      return _normalize(_configuredBaseUrl);
    }
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api/v1';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8000/api/v1';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return 'http://127.0.0.1:8000/api/v1';
      case TargetPlatform.fuchsia:
        return 'http://127.0.0.1:8000/api/v1';
    }
  }

  static String _normalize(String value) {
    final String trimmed = value.trim();
    final Uri? uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return trimmed;
    }

    final String normalizedPath;
    if (uri.path.isEmpty || uri.path == '/') {
      normalizedPath = '/api/v1';
    } else {
      normalizedPath =
          uri.path.endsWith('/')
              ? uri.path.substring(0, uri.path.length - 1)
              : uri.path;
    }

    return uri.replace(path: normalizedPath).toString();
  }
}
