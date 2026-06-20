import 'package:firebase_analytics/firebase_analytics.dart';

import '../config/app_config.dart';
import '../logger/logger_service.dart';

class AnalyticsService {
final LoggerService _logger;
final FirebaseAnalytics? _analytics;

AnalyticsService(this._logger)
: _analytics = AppConfig.enableAnalytics
? FirebaseAnalytics.instance
: null;

Future<void> logProfileSwapped({
required String fromProfile,
required String toProfile,
}) async {
if (_analytics == null) {
_logger.i(
'Analytics disabled; skipped profile_swapped event: '
'$fromProfile -> $toProfile',
);
return;
}

try {
  await _analytics!.logEvent(
    name: 'profile_swapped',
    parameters: {
      'from_profile': fromProfile,
      'to_profile': toProfile,
    },
  );

  print(
    '✅ Firebase Analytics Event Sent: '
    '$fromProfile -> $toProfile',
  );

  _logger.i(
    'Logged profile_swapped: '
    '$fromProfile -> $toProfile',
  );
} catch (e, stackTrace) {
  _logger.w(
    'Failed to log profile_swapped',
    e,
    stackTrace,
  );
}

}
}
