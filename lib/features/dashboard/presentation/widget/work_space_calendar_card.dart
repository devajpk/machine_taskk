import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_taskk/features/dashboard/domain/entities/activity_counts.dart';
import 'package:machine_taskk/features/dashboard/presentation/bloc/calendar_activity_bloc.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/calendar_activity_list.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/calendar_header.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/calendar_indicators.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';
import 'package:table_calendar/table_calendar.dart';

const _themeTransition = Duration(milliseconds: 220);
const _themeCurve = Curves.easeOutCubic;

class WorkspaceCalendar extends StatefulWidget {
  final WorkspaceProfile profile;
  final ProfileBranding branding;

  const WorkspaceCalendar({
    super.key,
    required this.profile,
    required this.branding,
  });

  @override
  State<WorkspaceCalendar> createState() => _WorkspaceCalendarState();
}

class _WorkspaceCalendarState extends State<WorkspaceCalendar> {
  @override
  void initState() {
    super.initState();
    context.read<CalendarActivityBloc>().add(
          LoadCalendarActivitiesEvent(profile: widget.profile),
        );
  }

  @override
  void didUpdateWidget(covariant WorkspaceCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      context.read<CalendarActivityBloc>().add(
            LoadCalendarActivitiesEvent(
              profile: widget.profile,
              showLoading: false,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final branding = widget.branding;
    final cornerRadius = branding.cellBorderRadius;
    final contentPadding = branding.dynamicScaling ? 18.0 : 16.0;

    return AnimatedContainer(
      duration: _themeTransition,
      curve: _themeCurve,
      width: double.infinity,
      padding: EdgeInsets.all(contentPadding),
      decoration: BoxDecoration(
        color: branding.surfaceColor,
        borderRadius: cornerRadius,
        border: Border.all(color: branding.headerColor.withValues(alpha: 0.14)),
        boxShadow: branding.monochrome
            ? null
            : [
                BoxShadow(
                  color: branding.markerColor.withValues(alpha: 0.14),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: BlocBuilder<CalendarActivityBloc, CalendarActivityState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is CalendarActivityError) {
            return _CalendarMessage(
              branding: branding,
              icon: Icons.error_outline_rounded,
              title: 'Calendar unavailable',
              description: state.message,
              onRetry: () {
                context.read<CalendarActivityBloc>().add(
                      LoadCalendarActivitiesEvent(profile: widget.profile),
                    );
              },
            );
          }

          if (state is! CalendarActivityLoaded) {
            return _CalendarLoading(branding: branding);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalendarHeader(
                focusedDay: state.focusedDay,
                branding: branding,
                onPreviousMonth: () {
                  context.read<CalendarActivityBloc>().add(
                        FocusCalendarMonthEvent(
                          DateTime(
                            state.focusedDay.year,
                            state.focusedDay.month - 1,
                          ),
                        ),
                      );
                },
                onNextMonth: () {
                  context.read<CalendarActivityBloc>().add(
                        FocusCalendarMonthEvent(
                          DateTime(
                            state.focusedDay.year,
                            state.focusedDay.month + 1,
                          ),
                        ),
                      );
                },
              ),
              const SizedBox(height: 12),
              TableCalendar<ActivityCounts>(
                firstDay: DateTime.utc(2020),
                lastDay: DateTime.utc(2035, 12, 31),
                focusedDay: state.focusedDay,
                selectedDayPredicate: (day) => isSameDay(
                  day,
                  state.selectedDay,
                ),
                eventLoader: (day) {
                  final counts = state.countsFor(day);
                  return counts.hasActivities ? [counts] : const [];
                },
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                },
                calendarFormat: CalendarFormat.month,
                headerVisible: false,
                daysOfWeekHeight: 32,
                rowHeight: branding.dynamicScaling ? 62 : 54,
                onPageChanged: (focusedDay) {
                  context.read<CalendarActivityBloc>().add(
                        FocusCalendarMonthEvent(focusedDay),
                      );
                },
                onDaySelected: (selectedDay, focusedDay) {
                  context.read<CalendarActivityBloc>().add(
                        SelectCalendarDayEvent(
                          selectedDay: selectedDay,
                          focusedDay: focusedDay,
                        ),
                      );
                },
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: branding.secondaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                  weekendStyle: TextStyle(
                    color: branding.secondaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  markersMaxCount: 0,
                  cellMargin: EdgeInsets.all(branding.monochrome ? 2 : 4),
                  defaultDecoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  weekendDecoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  outsideDecoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  disabledDecoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  holidayDecoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: branding.selectedDayColor,
                    borderRadius: cornerRadius,
                    shape: BoxShape.rectangle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: branding.todayColor.withValues(alpha: 0.18),
                    border: Border.all(color: branding.todayColor, width: 1.4),
                    borderRadius: cornerRadius,
                    shape: BoxShape.rectangle,
                  ),
                  defaultTextStyle: TextStyle(
                    color: branding.primaryTextColor,
                  ),
                  weekendTextStyle: TextStyle(
                    color: branding.primaryTextColor,
                  ),
                  selectedTextStyle: TextStyle(
                    color: _bestForegroundFor(branding.selectedDayColor),
                    fontWeight: FontWeight.w800,
                  ),
                  todayTextStyle: TextStyle(
                    color: branding.primaryTextColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                calendarBuilders: CalendarBuilders<ActivityCounts>(
                  defaultBuilder: (context, day, focusedDay) {
                    return CalendarDayCell(
                      day: day,
                      branding: branding,
                      counts: state.countsFor(day),
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    return CalendarDayCell(
                      day: day,
                      branding: branding,
                      counts: state.countsFor(day),
                      isToday: true,
                    );
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    return CalendarDayCell(
                      day: day,
                      branding: branding,
                      counts: state.countsFor(day),
                      isSelected: true,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              CalendarActivityList(
                selectedDay: state.selectedDay,
                todos: state.selectedTodos,
                events: state.selectedEvents,
                branding: branding,
              ),
            ],
          );
        },
      ),
    );
  }
}

class CalendarDayCell extends StatelessWidget {
  final DateTime day;
  final ProfileBranding branding;
  final ActivityCounts counts;
  final bool isSelected;
  final bool isToday;

  const CalendarDayCell({
    super.key,
    required this.day,
    required this.branding,
    required this.counts,
    this.isSelected = false,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasActivities = counts.hasActivities;
    final foreground = isSelected
        ? _bestForegroundFor(branding.selectedDayColor)
        : branding.primaryTextColor;

    return AnimatedContainer(
      duration: _themeTransition,
      curve: _themeCurve,
      margin: EdgeInsets.all(branding.monochrome ? 2 : 4),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? branding.selectedDayColor
            : hasActivities
                ? branding.markerColor.withValues(
                    alpha: branding.monochrome ? 0.08 : 0.11,
                  )
                : Colors.transparent,
        borderRadius: branding.cellBorderRadius,
        border: isToday && !isSelected
            ? Border.all(color: branding.todayColor, width: 1.4)
            : branding.monochrome && hasActivities
                ? Border.all(
                    color: branding.markerColor.withValues(alpha: 0.35),
                  )
                : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              color: foreground,
              fontWeight: hasActivities || isSelected
                  ? FontWeight.w800
                  : FontWeight.w500,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 3),
          CalendarIndicators(counts: counts),
        ],
      ),
    );
  }
}

class _CalendarLoading extends StatelessWidget {
  final ProfileBranding branding;

  const _CalendarLoading({required this.branding});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Center(
        child: CircularProgressIndicator(
          color: branding.markerColor,
          strokeWidth: 2.4,
        ),
      ),
    );
  }
}

class _CalendarMessage extends StatelessWidget {
  final ProfileBranding branding;
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onRetry;

  const _CalendarMessage({
    required this.branding,
    required this.icon,
    required this.title,
    required this.description,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: branding.secondaryTextColor, size: 36),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: branding.primaryTextColor,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: branding.secondaryTextColor,
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

Color _bestForegroundFor(Color color) {
  return color.computeLuminance() > 0.45 ? Colors.black87 : Colors.white;
}
