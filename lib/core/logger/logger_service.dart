import 'package:logger/logger.dart';

class LoggerService {
  final Logger _logger;
  LoggerService._(this._logger);

  factory LoggerService() {
    return LoggerService._(Logger(
      printer: PrettyPrinter(methodCount: 0),
    ));
  }

  void i(String message) => _logger.i(message);
  void d(String message) => _logger.d(message);
  void w(String message) => _logger.w(message);
  void e(String message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message, error, stackTrace);
}
