import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_config.dart';
import '../logger/logger_service.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  final LoggerService logger;

  AuthInterceptor(
    this.secureStorage,
    this.logger,
  );

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await secureStorage.read(
        key: SecureStorageKeys.authToken,
      );

      options.headers.addAll({
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      });

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] =
            '${AppConfig.authHeaderPrefix} $token';

        logger.d(
          'Authorization header injected: ${options.uri}',
        );
      }

      logger.d(
        'REQUEST => ${options.method} ${options.uri}',
      );

      handler.next(options);
    } catch (e, stackTrace) {
      logger.e(
        'AuthInterceptor Error',
        e,
        stackTrace,
      );

      handler.next(options);
    }
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    logger.d(
      'RESPONSE => ${response.statusCode} ${response.requestOptions.uri}',
    );

    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (err.response?.statusCode == 401) {
      logger.w('Unauthorized Request');
    }

    logger.e(
      'DIO ERROR => ${err.message}',
      err.error,
      err.stackTrace,
    );

    handler.next(err);
  }
}