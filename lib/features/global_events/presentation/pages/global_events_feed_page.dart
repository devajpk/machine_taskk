import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:machine_taskk/features/global_events/presentation/bloc/global_event_bloc.dart';
import 'package:machine_taskk/features/global_events/presentation/widgets/cached_event_image.dart';
import 'package:machine_taskk/features/global_events/presentation/widgets/global_events_shimmer.dart';

class GlobalEventsFeedPage extends StatefulWidget {
  const GlobalEventsFeedPage({super.key});

  @override
  State<GlobalEventsFeedPage> createState() => _GlobalEventsFeedPageState();
}

class _GlobalEventsFeedPageState extends State<GlobalEventsFeedPage> {
  @override
  void initState() {
    super.initState();
    context.read<GlobalEventBloc>().add(
          LoadGlobalEventsEvent(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GlobalEventBloc, GlobalEventState>(
      listener: (context, state) {
        if (state is GlobalEventError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Global Events'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<GlobalEventBloc>().add(
                      RefreshGlobalEventsEvent(),
                    );
              },
            ),
          ],
        ),
        body: BlocBuilder<GlobalEventBloc, GlobalEventState>(
          builder: (context, state) {
            /// Loading
            if (state is GlobalEventLoading) {
              return const GlobalEventsShimmer();
            }

            /// Loaded
            if (state is GlobalEventLoaded) {
              final events = state.events;

              if (events.isEmpty) {
                return const Center(
                  child: Text('No events available'),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<GlobalEventBloc>().add(
                        RefreshGlobalEventsEvent(),
                      );
                },
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: CachedEventImage(
                          imageUrl: event.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: Text(
                          event.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${event.eventDate.day}/${event.eventDate.month}/${event.eventDate.year}',
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                        onTap: () {
                          GoRouter.of(context).push(
                            '/event/${event.id}',
                            extra: event,
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }

            /// Initial error state
            if (state is GlobalEventError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 70,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<GlobalEventBloc>().add(
                                LoadGlobalEventsEvent(),
                              );
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}