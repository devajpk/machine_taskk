import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_switcher.dart';
import 'package:machine_taskk/features/todos/presentation/pages/todos_page.dart';

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
