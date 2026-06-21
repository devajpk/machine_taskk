import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:machine_taskk/features/global_events/presentation/bloc/global_event_bloc.dart';
import 'package:machine_taskk/features/global_events/presentation/widgets/cached_event_image.dart';
import 'package:machine_taskk/features/global_events/presentation/widgets/global_events_shimmer.dart';

class GlobalEventsFeedPage extends StatefulWidget {
  @override
  State<GlobalEventsFeedPage> createState() => _GlobalEventsFeedPageState();
}

class _GlobalEventsFeedPageState extends State<GlobalEventsFeedPage> {
  @override
  void initState() {
    super.initState();
    context.read<GlobalEventBloc>().add(LoadGlobalEventsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Global Events'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<GlobalEventBloc>().add(RefreshGlobalEventsEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<GlobalEventBloc, GlobalEventState>(
        builder: (context, state) {
         if (state is GlobalEventLoading) {
  return const GlobalEventsShimmer();
}

          if (state is GlobalEventLoaded) {
            final events = state.events;
            if (events.isEmpty) {
              return Center(child: Text('No events available'));
            }

            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: CachedEventImage(
                      imageUrl: event.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: Text(event.title, maxLines: 1),
                    subtitle: Text(
                      '${event.eventDate.month}/${event.eventDate.day}/${event.eventDate.year}',
                    ),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      GoRouter.of(context).push(
                        '/event/${event.id}',
                        extra: event,
                      );
                    },
                  ),
                );
              },
            );
          }

          if (state is GlobalEventError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<GlobalEventBloc>()
                          .add(LoadGlobalEventsEvent());
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
