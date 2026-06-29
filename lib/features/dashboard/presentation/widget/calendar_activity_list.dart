import 'package:flutter/material.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/activity_tile.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/day_header.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/empty_calendar_state.dart';
import 'package:machine_taskk/features/global_events/domain/entities/global_event.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';
import 'package:machine_taskk/features/todos/domain/entities/todo.dart';

class CalendarActivityList extends StatelessWidget {
  final DateTime selectedDay;
  final List<Todo> todos;
  final List<GlobalEvent> events;
  final ProfileBranding branding;

  const CalendarActivityList({
    super.key,
    required this.selectedDay,
    required this.todos,
    required this.events,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    final hasActivities = todos.isNotEmpty || events.isNotEmpty;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeOutCubic,
      child: Column(
        key: ValueKey(
          '${selectedDay.toIso8601String()}-${todos.length}-${events.length}',
        ),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DayHeader(
            selectedDay: selectedDay,
            todoCount: todos.length,
            eventCount: events.length,
            branding: branding,
          ),
          const SizedBox(height: 12),
          if (!hasActivities)
            EmptyCalendarState(branding: branding)
          else ...[
            if (todos.isNotEmpty) ...[
              _SectionLabel(
                label: 'Local Todos',
                branding: branding,
              ),
              const SizedBox(height: 8),
              ...todos.map(
                (todo) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ActivityTile(
                    title: todo.title,
                    date: todo.createdAt,
                    type: ActivityTileType.todo,
                    completed: todo.isCompleted,
                    branding: branding,
                  ),
                ),
              ),
            ],
            if (events.isNotEmpty) ...[
              const SizedBox(height: 4),
              _SectionLabel(
                label: 'Global Events',
                branding: branding,
              ),
              const SizedBox(height: 8),
              ...events.map(
                (event) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ActivityTile(
                    title: event.title,
                    date: event.eventDate,
                    type: ActivityTileType.event,
                    branding: branding,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final ProfileBranding branding;

  const _SectionLabel({
    required this.label,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: branding.secondaryTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
    );
  }
}
