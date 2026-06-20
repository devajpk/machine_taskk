import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:machine_taskk/core/config/app_config.dart';
import 'package:machine_taskk/core/logger/logger_service.dart';

class AnalyticsService {
  final LoggerService _logger;
  final FirebaseAnalytics? _analytics;

  AnalyticsService(this._logger) : _analytics = _initializeAnalytics();

  static FirebaseAnalytics? _initializeAnalytics() {
    if (!AppConfig.enableAnalytics) return null;
    try {
      return FirebaseAnalytics.instance;
    } catch (_) {
      // Firebase may not be fully configured in every environment.
      return null;
    }
  }

  Future<void> logProfileSwapped(String profileKey) async {
    if (_analytics == null) {
      _logger.i(
        'profile_swapped: $profileKey (analytics disabled or unavailable)',
      );
      return;
    }

    try {
      await _analytics!.logEvent(
        name: 'profile_swapped',
        parameters: {'profile': profileKey},
      );
      _logger.i('Logged analytics event profile_swapped for $profileKey');
    } catch (error, stackTrace) {
      _logger.w(
        'Failed to log analytics event profile_swapped',
        error,
        stackTrace,
      );
    }
  }
}

class CrashlyticsService {
  final LoggerService _logger;
  final FirebaseCrashlytics? _crashlytics;

  CrashlyticsService(this._logger) : _crashlytics = _initializeCrashlytics();

  static FirebaseCrashlytics? _initializeCrashlytics() {
    if (!AppConfig.enableCrashlytics) return null;
    try {
      return FirebaseCrashlytics.instance;
    } catch (_) {
      return null;
    }
  }

  Future<void> recordError(dynamic error, StackTrace? stackTrace) async {
    if (_crashlytics == null) {
      _logger.e(
        'Crashlytics stubbed; error captured locally',
        error,
        stackTrace,
      );
      return;
    }

    try {
      await _crashlytics!.recordError(error, stackTrace);
      _logger.i('Crashlytics recorded error');
    } catch (recordError, recordStackTrace) {
      _logger.w(
        'Failed to send error to Crashlytics',
        recordError,
        recordStackTrace,
      );
    }
  }
}
