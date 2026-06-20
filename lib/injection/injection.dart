import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/logger/logger_service.dart';
import '../core/network/network_info.dart';
import '../core/network/auth_interceptor.dart';
import '../core/network/network_service.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  getIt.registerLazySingleton<LoggerService>(() => LoggerService());
  getIt.registerLazySingleton(() => Connectivity());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));
  getIt.registerLazySingleton(() => FlutterSecureStorage());

  // Dio
  getIt.registerLazySingleton<Dio>(() {
    final dio =
        Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));
    
    dio.interceptors.add(AuthInterceptor(getIt(), getIt()));
    return dio;
  });

  // NetworkService
  getIt.registerLazySingleton<NetworkService>(
      () => NetworkService(getIt(), getIt()));
}
