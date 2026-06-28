import 'package:flutter/foundation.dart';

class AppConfig {
  static const _configuredApiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    if (_configuredApiBaseUrl.isNotEmpty) {
      return _configuredApiBaseUrl;
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000/api';
    }

    return 'http://localhost:5000/api';
  }
}
