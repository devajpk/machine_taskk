part of 'calendar_activity_bloc.dart';

abstract class CalendarActivityEvent extends Equatable {
  const CalendarActivityEvent();

  @override
  List<Object?> get props => [];
}

class LoadCalendarActivitiesEvent extends CalendarActivityEvent {
  final WorkspaceProfile profile;
  final DateTime? selectedDay;
  final DateTime? focusedDay;
  final bool showLoading;

  const LoadCalendarActivitiesEvent({
    required this.profile,
    this.selectedDay,
    this.focusedDay,
    this.showLoading = true,
  });

  @override
  List<Object?> get props => [
        profile,
        selectedDay,
        focusedDay,
        showLoading,
      ];
}

class RefreshCalendarActivitiesEvent extends CalendarActivityEvent {
  final WorkspaceProfile profile;

  const RefreshCalendarActivitiesEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}

class SelectCalendarDayEvent extends CalendarActivityEvent {
  final DateTime selectedDay;
  final DateTime focusedDay;

  const SelectCalendarDayEvent({
    required this.selectedDay,
    required this.focusedDay,
  });

  @override
  List<Object?> get props => [selectedDay, focusedDay];
}

class FocusCalendarMonthEvent extends CalendarActivityEvent {
  final DateTime focusedDay;

  const FocusCalendarMonthEvent(this.focusedDay);

  @override
  List<Object?> get props => [focusedDay];
}
