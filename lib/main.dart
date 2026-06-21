import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:machine_taskk/core/crash_lytics/crashlytics_service.dart';
import 'package:machine_taskk/features/global_events/domain/repo/repo.dart';
import 'package:machine_taskk/firebase_options.dart';

import 'injection/injection.dart';



import 'features/profiles/presentation/bloc/profile_bloc.dart';
import 'features/profiles/data/profile_repository_impl.dart';
import 'features/profiles/domain/entities/workspace_profile.dart';

import 'features/global_events/presentation/bloc/global_event_bloc.dart';

import 'core/routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();

  await initDependencies();

  // Crashlytics Handler
  FlutterError.onError = (FlutterErrorDetails details) {
    getIt<CrashlyticsService>().recordError(
      details.exception,
      details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (
    error,
    stack,
  ) {
    getIt<CrashlyticsService>().recordError(
      error,
      stack,
    );
    return true;
  };

  final profileRepo = ProfileRepositoryImpl();

  final initialProfile =
      await profileRepo.getCurrentProfile();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileBloc(
            profileRepo,
            getIt(),
          )..add(
              LoadProfileEvent(),
            ),
        ),
        BlocProvider(
          create: (_) => GlobalEventBloc(
            getIt<GlobalEventRepository>(),
          ),
        ),
      ],
      child: MyApp(
        initialProfile: initialProfile,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final WorkspaceProfile initialProfile;

  const MyApp({
    super.key,
    required this.initialProfile,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Multi Profile Workspace Engine',
      routerConfig: AppRouter.router,
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}