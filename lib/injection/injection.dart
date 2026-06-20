import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/logger/logger_service.dart';
import '../core/network/network_info.dart';
import '../core/network/auth_interceptor.dart';
import '../core/network/network_service.dart';
import '../core/config/app_config.dart';
import '../core/security/secure_token_service.dart';
import '../features/global_events/data/global_event_service.dart';
import '../features/global_events/data/global_event_repository_impl.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  getIt.registerLazySingleton<LoggerService>(() => LoggerService());
  getIt.registerLazySingleton(() => Connectivity());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));
  getIt.registerLazySingleton(
      () => FlutterSecureStorage()); // Change to allow multiple initialization
  getIt.registerLazySingleton<SecureTokenService>(
      () => SecureTokenService(getIt<FlutterSecureStorage>()));

  // Dio
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
    dio.options.connectTimeout = Duration(seconds: AppConfig.apiTimeoutSeconds);
    dio.options.receiveTimeout = Duration(seconds: AppConfig.apiTimeoutSeconds);
    dio.interceptors.add(AuthInterceptor(getIt(), getIt()));
    return dio;
  });

  // NetworkService
  getIt.registerLazySingleton<NetworkService>(
      () => NetworkService(getIt(), getIt()));

  // Global Events
  getIt.registerLazySingleton<GlobalEventService>(
      () => GlobalEventService(getIt<NetworkService>(), getIt<NetworkInfo>()));
  getIt.registerLazySingleton<GlobalEventRepository>(
      () => GlobalEventRepositoryImpl(getIt()));
}
