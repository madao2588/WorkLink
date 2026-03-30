import 'package:flutter/foundation.dart';

class AppApiConfig {
  static String get baseUrl {
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
}
