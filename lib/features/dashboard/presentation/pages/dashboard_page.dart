import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../profiles/domain/entities/workspace_profile.dart';
import '../../profiles/presentation/bloc/profile_bloc.dart';
import '../../profiles/presentation/widgets/profile_switcher.dart';
import '../../todos/presentation/pages/todos_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (ctx, state) => DashboardPage()),
      GoRoute(path: '/todos', builder: (ctx, state) => TodosPage()),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi Profile Workspace Engine')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileSwitcher(),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => GoRouter.of(context).push('/todos'),
              icon: const Icon(Icons.list),
              label: const Text('Open Todos'),
            ),
          ],
        ),
      ),
    );
  }
}
