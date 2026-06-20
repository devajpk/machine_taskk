/// Application environment configuration
abstract class AppConfig {
  /// API base URL
  static const String apiBaseUrl = 'https://jsonplaceholder.typicode.com';

  /// API timeout in seconds
  static const int apiTimeoutSeconds = 10;

  /// Enable debug logging
  static const bool debugLogging = true;

  /// Enable Firebase analytics
  static const bool enableAnalytics = true;

  /// Enable Firebase crashlytics
  static const bool enableCrashlytics = true;

  /// Default authorization header prefix
  static const String authHeaderPrefix = 'Bearer';
}

/// Secure Storage Keys
abstract class SecureStorageKeys {
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
}

/// Feature Flags
abstract class FeatureFlags {
  static const bool enableOfflineMode = true;
  static const bool enableProfileSwitching = true;
  static const bool enableGlobalEvents = true;
  static const bool enableCalendarIntegration = true;
}
