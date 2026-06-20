import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_switcher.dart';

class DashboardPage extends StatelessWidget {
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
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => GoRouter.of(context).push('/todos'),
              icon: const Icon(Icons.list),
              label: const Text('My Todos'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => GoRouter.of(context).push('/events'),
              icon: const Icon(Icons.public),
              label: const Text('Global Events'),
            ),
          ],
        ),
      ),
    );
  }
}
