import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'injection/injection.dart';
import 'features/profiles/presentation/bloc/profile_bloc.dart';
import 'features/profiles/data/profile_repository_impl.dart';
import 'features/profiles/domain/entities/workspace_profile.dart';
import 'features/global_events/presentation/bloc/global_event_bloc.dart';
import 'features/global_events/data/global_event_repository_impl.dart';
import 'core/routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initDependencies();

  final profileRepo = ProfileRepositoryImpl();
  final initialProfile = await profileRepo.getCurrentProfile();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
          create: (_) => ProfileBloc(profileRepo)..add(LoadProfileEvent())),
      BlocProvider(
          create: (_) => GlobalEventBloc(getIt<GlobalEventRepository>())),
    ],
    child: MyApp(initialProfile: initialProfile),
  ));
}

class MyApp extends StatelessWidget {
  final WorkspaceProfile initialProfile;
  const MyApp({super.key, required this.initialProfile});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Multi Profile Workspace Engine',
      routerConfig: AppRouter.router,
      theme: ThemeData(useMaterial3: true),
    );
  }
}
