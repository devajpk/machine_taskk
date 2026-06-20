import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../config/app_config.dart';
import '../logger/logger_service.dart';

class CrashlyticsService {
  final LoggerService _logger;
  final FirebaseCrashlytics? _crashlytics;

  CrashlyticsService(this._logger)
      : _crashlytics = AppConfig.enableCrashlytics
            ? FirebaseCrashlytics.instance
            : null;

  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace,
  ) async {
    if (_crashlytics == null) {
      _logger.e(
        'Crashlytics stubbed; error captured locally',
        error,
        stackTrace,
      );
      return;
    }

    try {
      await _crashlytics!.recordError(
        error,
        stackTrace,
      );

      _logger.i('Crashlytics recorded error');
    } catch (e, st) {
      _logger.w(
        'Failed to send error to Crashlytics',
        e,
        st,
      );
    }
  }
}