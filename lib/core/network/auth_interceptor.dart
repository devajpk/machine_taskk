import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../logger/logger_service.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  final LoggerService logger;

  AuthInterceptor(this.secureStorage, this.logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await secureStorage.read(key: 'auth_token');
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      logger.d('Request: ${options.method} ${options.uri}');
    } catch (e) {
      logger.w('AuthInterceptor onRequest error: $e');
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('Response: ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    logger.e('DioError: ${err.message}', err);
    handler.next(err);
  }
}
