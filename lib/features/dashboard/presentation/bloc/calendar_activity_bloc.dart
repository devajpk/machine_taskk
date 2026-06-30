import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_taskk/features/dashboard/domain/entities/activity_counts.dart';
import 'package:machine_taskk/features/dashboard/domain/usecases/calendar_activity_use_cases.dart';
import 'package:machine_taskk/features/global_events/domain/entities/global_event.dart';
import 'package:machine_taskk/features/global_events/domain/repo/repo.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';
import 'package:machine_taskk/features/todos/domain/entities/todo.dart';
import 'package:machine_taskk/features/todos/domain/repo/todo_repositories.dart';

part 'calendar_activity_event.dart';
part 'calendar_activity_state.dart';

class CalendarActivityBloc
    extends Bloc<CalendarActivityEvent, CalendarActivityState> {
  final TodoRepository todoRepository;
  final GlobalEventRepository globalEventRepository;
  final CalendarActivityUseCases useCases;
  late final StreamSubscription<WorkspaceProfile> _todoChangesSubscription;

  CalendarActivityBloc({
    required this.todoRepository,
    required this.globalEventRepository,
    required this.useCases,
  }) : super(CalendarActivityLoading()) {
    on<LoadCalendarActivitiesEvent>(_onLoadCalendarActivities);
    on<RefreshCalendarActivitiesEvent>(_onRefreshCalendarActivities);
    on<SelectCalendarDayEvent>(_onSelectCalendarDay);
    on<FocusCalendarMonthEvent>(_onFocusCalendarMonth);

    _todoChangesSubscription = todoRepository.todoChanges.listen(
      _onTodoChanged,
    );
  }

  void _onTodoChanged(WorkspaceProfile profile) {
    final current = state;
    if (current is CalendarActivityLoaded && current.profile == profile) {
      add(RefreshCalendarActivitiesEvent(profile));
    }
  }

  Future<void> _onLoadCalendarActivities(
    LoadCalendarActivitiesEvent event,
    Emitter<CalendarActivityState> emit,
  ) async {
    await _load(
      emit: emit,
      profile: event.profile,
      selectedDay: event.selectedDay ?? DateTime.now(),
      focusedDay: event.focusedDay ?? DateTime.now(),
      showLoading: event.showLoading,
    );
  }

  Future<void> _onRefreshCalendarActivities(
    RefreshCalendarActivitiesEvent event,
    Emitter<CalendarActivityState> emit,
  ) async {
    final current = state;
    await _load(
      emit: emit,
      profile: event.profile,
      selectedDay:
          current is CalendarActivityLoaded ? current.selectedDay : null,
      focusedDay: current is CalendarActivityLoaded ? current.focusedDay : null,
      showLoading: false,
    );
  }

  void _onSelectCalendarDay(
    SelectCalendarDayEvent event,
    Emitter<CalendarActivityState> emit,
  ) {
    final current = state;
    if (current is! CalendarActivityLoaded) return;

    emit(
      current.copyWith(
        selectedDay: useCases.normalizeDate(event.selectedDay),
        focusedDay: useCases.normalizeDate(event.focusedDay),
      ),
    );
  }

  void _onFocusCalendarMonth(
    FocusCalendarMonthEvent event,
    Emitter<CalendarActivityState> emit,
  ) {
    final current = state;
    if (current is! CalendarActivityLoaded) return;

    emit(
      current.copyWith(
        focusedDay: useCases.normalizeDate(event.focusedDay),
      ),
    );
  }

  Future<void> _load({
    required Emitter<CalendarActivityState> emit,
    required WorkspaceProfile profile,
    DateTime? selectedDay,
    DateTime? focusedDay,
    bool showLoading = true,
  }) async {
    final normalizedSelectedDay = useCases.normalizeDate(
      selectedDay ?? DateTime.now(),
    );
    final normalizedFocusedDay = useCases.normalizeDate(
      focusedDay ?? normalizedSelectedDay,
    );

    if (showLoading) {
      emit(
        CalendarActivityLoading(
          selectedDay: normalizedSelectedDay,
          focusedDay: normalizedFocusedDay,
        ),
      );
    }

    try {
      final todos = await todoRepository.getTodos(profile);
      final events = await globalEventRepository.getEvents();
      final counts = useCases.getActivityCounts(
        todos: todos,
        events: events,
      );

      emit(
        CalendarActivityLoaded(
          profile: profile,
          todos: todos,
          events: events,
          activityCounts: counts,
          selectedDay: normalizedSelectedDay,
          focusedDay: normalizedFocusedDay,
          useCases: useCases,
        ),
      );
    } catch (error) {
      emit(
        CalendarActivityError(
          message: error.toString(),
          selectedDay: normalizedSelectedDay,
          focusedDay: normalizedFocusedDay,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _todoChangesSubscription.cancel();
    return super.close();
  }
}
