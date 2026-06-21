import 'dart:io';

import 'package:dio/dio.dart';

import '../exceptions/exceptions.dart';
import '../logger/logger_service.dart';

class NetworkService {
  final Dio _dio;
  final LoggerService logger;

  NetworkService(
    this._dio,
    this.logger,
  );

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Never _handleDioError(DioException e) {
    logger.e(
      'Network Error',
     
    );

    /// No Internet
    if (e.error is SocketException) {
      throw Exception('No internet connection');
    }

    /// Timeout Errors
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw Exception(
        'Connection timeout. Please try again.',
      );
    }

    /// Request Cancelled
    if (e.type == DioExceptionType.cancel) {
      throw Exception(
        'Request cancelled',
      );
    }

    /// SSL / Handshake issues
    if (e.error is HandshakeException) {
      throw Exception(
        'Secure connection failed',
      );
    }

    /// Response Errors
    if (e.response != null) {
      final statusCode = e.response?.statusCode ?? 0;

      switch (statusCode) {
        case 400:
          throw Exception('Bad request');

        case 401:
        case 403:
          throw UnauthorizedException();

        case 404:
          throw Exception('Resource not found');

        case 500:
        case 502:
        case 503:
        case 504:
          throw ServerException(
            'Server error. Please try again later.',
          );

        default:
          throw Exception(
            'Request failed. Status code: $statusCode',
          );
      }
    }

    /// Unknown Error
    throw UnknownException(
      e.message ?? 'Something went wrong',
    );
  }
}