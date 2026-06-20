import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_taskk/features/global_events/domain/entities/global_event.dart';
import 'package:machine_taskk/features/global_events/presentation/bloc/global_event_bloc.dart';
import 'package:machine_taskk/features/global_events/presentation/pages/global_events_feed_page.dart';
import 'package:machine_taskk/features/global_events/presentation/pages/event_details_page.dart';
import 'package:machine_taskk/features/global_events/data/global_event_repository_impl.dart';
import 'package:machine_taskk/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:machine_taskk/features/todos/presentation/pages/todos_page.dart';
import 'package:machine_taskk/injection/injection.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => DashboardPage(),
        routes: [
          GoRoute(
            path: 'todos',
            builder: (context, state) => TodosPage(),
          ),
          GoRoute(
            path: 'events',
            builder: (context, state) => BlocProvider(
              create: (context) => GlobalEventBloc(
                getIt.get<GlobalEventRepository>(),
              ),
              child: GlobalEventsFeedPage(),
            ),
          ),
          GoRoute(
            path: 'event/:id',
            builder: (context, state) {
              final eventId = int.parse(state.pathParameters['id'] ?? '0');
              // Parse event data from extra if passed
              final event = state.extra as GlobalEvent?;
              if (event != null) {
                return EventDetailsPage(event: event);
              }
              // Fallback: display error
              return Scaffold(
                appBar: AppBar(title: Text('Event')),
                body: Center(
                  child: Text('Event not found'),
                ),
              );
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found:'),
      ),
    ),
  );
}
