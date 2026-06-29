part of 'calendar_activity_bloc.dart';

abstract class CalendarActivityState extends Equatable {
  final DateTime selectedDay;
  final DateTime focusedDay;

  const CalendarActivityState({
    required this.selectedDay,
    required this.focusedDay,
  });

  @override
  List<Object?> get props => [selectedDay, focusedDay];
}

class CalendarActivityLoading extends CalendarActivityState {
  CalendarActivityLoading({
    DateTime? selectedDay,
    DateTime? focusedDay,
  }) : super(
          selectedDay: selectedDay ?? DateTime.now(),
          focusedDay: focusedDay ?? DateTime.now(),
        );
}

class CalendarActivityLoaded extends CalendarActivityState {
  final WorkspaceProfile profile;
  final List<Todo> todos;
  final List<GlobalEvent> events;
  final Map<DateTime, ActivityCounts> activityCounts;
  final CalendarActivityUseCases useCases;

  const CalendarActivityLoaded({
    required this.profile,
    required this.todos,
    required this.events,
    required this.activityCounts,
    required super.selectedDay,
    required super.focusedDay,
    required this.useCases,
  });

  List<Todo> get selectedTodos => useCases.getTodosForDate(
        todos,
        selectedDay,
      );

  List<GlobalEvent> get selectedEvents => useCases.getEventsForDate(
        events,
        selectedDay,
      );

  ActivityCounts countsFor(DateTime day) {
    return activityCounts[useCases.normalizeDate(day)] ??
        const ActivityCounts();
  }

  CalendarActivityLoaded copyWith({
    WorkspaceProfile? profile,
    List<Todo>? todos,
    List<GlobalEvent>? events,
    Map<DateTime, ActivityCounts>? activityCounts,
    DateTime? selectedDay,
    DateTime? focusedDay,
    CalendarActivityUseCases? useCases,
  }) {
    return CalendarActivityLoaded(
      profile: profile ?? this.profile,
      todos: todos ?? this.todos,
      events: events ?? this.events,
      activityCounts: activityCounts ?? this.activityCounts,
      selectedDay: selectedDay ?? this.selectedDay,
      focusedDay: focusedDay ?? this.focusedDay,
      useCases: useCases ?? this.useCases,
    );
  }

  @override
  List<Object?> get props => [
        profile,
        todos,
        events,
        activityCounts,
        selectedDay,
        focusedDay,
      ];
}

class CalendarActivityError extends CalendarActivityState {
  final String message;

  const CalendarActivityError({
    required this.message,
    required super.selectedDay,
    required super.focusedDay,
  });

  @override
  List<Object?> get props => [message, selectedDay, focusedDay];
}
