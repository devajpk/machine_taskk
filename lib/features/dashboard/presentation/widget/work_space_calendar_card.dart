import 'package:flutter/material.dart';
import 'package:machine_taskk/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/calendar_header.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';
import 'package:table_calendar/table_calendar.dart';
const _themeTransition = Duration(milliseconds: 280);
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
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _focusedDay = DateTime(today.year, today.month, today.day);
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final branding = widget.branding;
    final events = _eventsFor(widget.profile, _focusedDay);
    final selectedEvents = _eventsForDay(events, _selectedDay);
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CalendarHeader(
            focusedDay: _focusedDay,
            branding: branding,
            onPreviousMonth: () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
              });
            },
            onNextMonth: () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
              });
            },
          ),
          const SizedBox(height: 12),
          TableCalendar<CalendarEvent>(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2035, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            eventLoader: (day) => _eventsForDay(events, day),
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            calendarFormat: CalendarFormat.month,
            headerVisible: false,
            daysOfWeekHeight: 32,
            rowHeight: branding.dynamicScaling ? 58 : 50,
            onPageChanged: (focusedDay) {
              setState(() => _focusedDay = focusedDay);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = _dateOnly(selectedDay);
                _focusedDay = focusedDay;
              });
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
            // FIX: table_calendar's CalendarStyle defaults several
            // decorations (default/weekend/outside/disabled/holiday/range/
            // markers) to `shape: BoxShape.circle`. We only explicitly
            // overrode selected/today before, so any other day cell that
            // picked up a borderRadius via theming/copyWith would hit:
            //   'shape != BoxShape.circle || borderRadius == null'
            // Every decoration below is now explicit: rectangle shapes get
            // an explicit borderRadius, and the one circle shape
            // (markerDecoration) carries NO borderRadius at all. Custom day
            // cells are still rendered through calendarBuilders below, so
            // these defaults mainly exist as a safety net.
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
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
              rangeStartDecoration: const BoxDecoration(
                shape: BoxShape.rectangle,
              ),
              rangeEndDecoration: const BoxDecoration(
                shape: BoxShape.rectangle,
              ),
              withinRangeDecoration: const BoxDecoration(
                shape: BoxShape.rectangle,
              ),
              // Circle shape with NO borderRadius — the only legal way to
              // combine the two properties.
              markerDecoration: const BoxDecoration(
                shape: BoxShape.circle,
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
              defaultTextStyle: TextStyle(color: branding.primaryTextColor),
              weekendTextStyle: TextStyle(color: branding.primaryTextColor),
              selectedTextStyle: TextStyle(
                color: _bestForegroundFor(branding.selectedDayColor),
                fontWeight: FontWeight.w800,
              ),
              todayTextStyle: TextStyle(
                color: branding.primaryTextColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            calendarBuilders: CalendarBuilders<CalendarEvent>(
              defaultBuilder: (context, day, focusedDay) {
                return CalendarDayCell(
                  day: day,
                  branding: branding,
                  events: _eventsForDay(events, day),
                );
              },
              markerBuilder: (context, day, dayEvents) {
                if (dayEvents.isEmpty) return const SizedBox.shrink();
                return CalendarMarkers(
                  events: dayEvents,
                  branding: branding,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SelectedDayAgenda(
            events: selectedEvents,
            branding: branding,
          ),
        ],
      ),
    );
  }

  Map<DateTime, List<CalendarEvent>> _eventsFor(
    WorkspaceProfile profile,
    DateTime focusedDay,
  ) {
    final month = DateTime(focusedDay.year, focusedDay.month);
    final events = switch (profile) {
      WorkspaceProfile.corporate => [
          CalendarEvent(month.add(const Duration(days: 2)), 'Board review'),
          CalendarEvent(
              month.add(const Duration(days: 7)), 'Compliance audit'),
          CalendarEvent(month.add(const Duration(days: 15)), 'Ops planning'),
          CalendarEvent(month.add(const Duration(days: 21)), 'Client report'),
        ],
      WorkspaceProfile.creative => [
          CalendarEvent(month.add(const Duration(days: 3)), 'Moodboard jam'),
          CalendarEvent(month.add(const Duration(days: 8)), 'Design sprint'),
          CalendarEvent(month.add(const Duration(days: 13)), 'Prototype lab'),
          CalendarEvent(month.add(const Duration(days: 19)), 'Launch story'),
          CalendarEvent(month.add(const Duration(days: 24)), 'Crit session'),
        ],
      WorkspaceProfile.work => [
          CalendarEvent(month.add(const Duration(days: 1)), 'Sprint sync'),
          CalendarEvent(month.add(const Duration(days: 10)), 'Roadmap review'),
          CalendarEvent(month.add(const Duration(days: 17)), 'Release check'),
        ],
      WorkspaceProfile.personal => [
          CalendarEvent(month.add(const Duration(days: 4)), 'Home planning'),
          CalendarEvent(month.add(const Duration(days: 12)), 'Wellness block'),
          CalendarEvent(month.add(const Duration(days: 22)), 'Family time'),
        ],
    };

    final today = DateTime.now();
    events.add(CalendarEvent(_dateOnly(today), '${profile.key} focus'));

    return events.fold(<DateTime, List<CalendarEvent>>{}, (map, event) {
      final key = _dateOnly(event.date);
      map.putIfAbsent(key, () => []).add(event);
      return map;
    });
  }

  List<CalendarEvent> _eventsForDay(
    Map<DateTime, List<CalendarEvent>> events,
    DateTime day,
  ) {
    return events[_dateOnly(day)] ?? const [];
  }
}
const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
Color _bestForegroundFor(Color color) {
  return color.computeLuminance() > 0.45 ? Colors.black87 : Colors.white;
}
DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);