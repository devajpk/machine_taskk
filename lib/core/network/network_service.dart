import 'dart:io';

import 'package:dio/dio.dart';
import '../exceptions/exceptions.dart';
import '../logger/logger_service.dart';

class NetworkService {
  final Dio _dio;
  final LoggerService logger;

  NetworkService(this._dio, this.logger);

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dio.get(path, queryParameters: queryParameters);
      return res;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Response> post(String path,
      {data, Map<String, dynamic>? queryParameters}) async {
    try {
      final res =
          await _dio.post(path, data: data, queryParameters: queryParameters);
      return res;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Response> put(String path,
      {data, Map<String, dynamic>? queryParameters}) async {
    try {
      final res =
          await _dio.put(path, data: data, queryParameters: queryParameters);
      return res;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Response> delete(String path,
      {data, Map<String, dynamic>? queryParameters}) async {
    try {
      final res =
          await _dio.delete(path, data: data, queryParameters: queryParameters);
      return res;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Never _handleDioError(DioError e) {
    logger.e('NetworkService DioError: ${e.message}');
    if (e.type == DioErrorType.sendTimeout ||
        e.type == DioErrorType.receiveTimeout) {
      throw SocketException('Timeout');
    }

    if (e.response != null) {
      final status = e.response?.statusCode ?? 0;
      if (status == 401 || status == 403) throw UnauthorizedException();
      if (status >= 500) throw ServerException();
      throw ServerException('Status: $status');
    }

    throw UnknownException(e.message ?? "Unknown DioError");
  }
}
