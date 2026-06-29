import 'package:machine_taskk/features/dashboard/domain/entities/activity_counts.dart';
import 'package:machine_taskk/features/global_events/domain/entities/global_event.dart';
import 'package:machine_taskk/features/todos/domain/entities/todo.dart';

class CalendarActivityUseCases {
  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<Todo> getTodosForDate(List<Todo> todos, DateTime date) {
    final selectedDate = normalizeDate(date);
    final filtered = todos
        .where((todo) => normalizeDate(todo.createdAt) == selectedDate)
        .toList();
    filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return filtered;
  }

  List<GlobalEvent> getEventsForDate(
    List<GlobalEvent> events,
    DateTime date,
  ) {
    final selectedDate = normalizeDate(date);
    final filtered = events
        .where((event) => normalizeDate(event.eventDate) == selectedDate)
        .toList();
    filtered.sort((a, b) => a.eventDate.compareTo(b.eventDate));
    return filtered;
  }

  Map<DateTime, ActivityCounts> getActivityCounts({
    required List<Todo> todos,
    required List<GlobalEvent> events,
  }) {
    final counts = <DateTime, ActivityCounts>{};

    for (final todo in todos) {
      final date = normalizeDate(todo.createdAt);
      final current = counts[date] ?? const ActivityCounts();
      counts[date] = current.copyWith(todoCount: current.todoCount + 1);
    }

    for (final event in events) {
      final date = normalizeDate(event.eventDate);
      final current = counts[date] ?? const ActivityCounts();
      counts[date] = current.copyWith(eventCount: current.eventCount + 1);
    }

    return counts;
  }
}
