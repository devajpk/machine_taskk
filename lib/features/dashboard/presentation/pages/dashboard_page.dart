import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_taskk/core/config/app_config.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';
import 'package:machine_taskk/features/profiles/presentation/bloc/profile_bloc.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_switcher.dart';
import 'package:table_calendar/table_calendar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profile =
            state is ProfileLoaded ? state.profile : WorkspaceProfile.personal;
        final branding = profile.branding;

        return Scaffold(
          backgroundColor: branding.backgroundColor,
          appBar: AppBar(
            title: const Text('Multi Profile Workspace Engine'),
            backgroundColor: branding.surfaceColor,
            foregroundColor: branding.primaryTextColor,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileSwitcher(),
                const SizedBox(height: 24),
                _ProfileSummary(profile: profile, branding: branding),
                if (FeatureFlags.enableCalendarIntegration) ...[
                  const SizedBox(height: 24),
                  _WorkspaceCalendar(profile: profile, branding: branding),
                ],
                const SizedBox(height: 24),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: branding.primaryTextColor,
                      ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => GoRouter.of(context).push('/todos'),
                      icon: const Icon(Icons.list),
                      label: const Text('My Todos'),
                    ),
                    ElevatedButton.icon(
                      onPressed: FeatureFlags.enableGlobalEvents
                          ? () => GoRouter.of(context).push('/events')
                          : null,
                      icon: const Icon(Icons.public),
                      label: const Text('Global Events'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _FeatureStatusPanel(branding: branding),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WorkspaceCalendar extends StatefulWidget {
  final WorkspaceProfile profile;
  final ProfileBranding branding;

  const _WorkspaceCalendar({
    required this.profile,
    required this.branding,
  });

  @override
  State<_WorkspaceCalendar> createState() => _WorkspaceCalendarState();
}

class _WorkspaceCalendarState extends State<_WorkspaceCalendar> {
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
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: EdgeInsets.all(contentPadding),
      decoration: BoxDecoration(
        color: branding.surfaceColor,
        borderRadius: BorderRadius.circular(branding.monochrome ? 0 : 8),
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
          _CalendarHeader(
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
          TableCalendar<_CalendarEvent>(
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
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              cellMargin: EdgeInsets.all(branding.monochrome ? 2 : 4),
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
            calendarBuilders: CalendarBuilders<_CalendarEvent>(
              defaultBuilder: (context, day, focusedDay) {
                return _CalendarDayCell(
                  day: day,
                  branding: branding,
                  events: _eventsForDay(events, day),
                );
              },
              markerBuilder: (context, day, dayEvents) {
                if (dayEvents.isEmpty) return const SizedBox.shrink();
                return _CalendarMarkers(
                  events: dayEvents,
                  branding: branding,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _SelectedDayAgenda(
            events: selectedEvents,
            branding: branding,
          ),
        ],
      ),
    );
  }

  Map<DateTime, List<_CalendarEvent>> _eventsFor(
    WorkspaceProfile profile,
    DateTime focusedDay,
  ) {
    final month = DateTime(focusedDay.year, focusedDay.month);
    final events = switch (profile) {
      WorkspaceProfile.corporate => [
          _CalendarEvent(month.add(const Duration(days: 2)), 'Board review'),
          _CalendarEvent(
              month.add(const Duration(days: 7)), 'Compliance audit'),
          _CalendarEvent(month.add(const Duration(days: 15)), 'Ops planning'),
          _CalendarEvent(month.add(const Duration(days: 21)), 'Client report'),
        ],
      WorkspaceProfile.creative => [
          _CalendarEvent(month.add(const Duration(days: 3)), 'Moodboard jam'),
          _CalendarEvent(month.add(const Duration(days: 8)), 'Design sprint'),
          _CalendarEvent(month.add(const Duration(days: 13)), 'Prototype lab'),
          _CalendarEvent(month.add(const Duration(days: 19)), 'Launch story'),
          _CalendarEvent(month.add(const Duration(days: 24)), 'Crit session'),
        ],
      WorkspaceProfile.work => [
          _CalendarEvent(month.add(const Duration(days: 1)), 'Sprint sync'),
          _CalendarEvent(month.add(const Duration(days: 10)), 'Roadmap review'),
          _CalendarEvent(month.add(const Duration(days: 17)), 'Release check'),
        ],
      WorkspaceProfile.personal => [
          _CalendarEvent(month.add(const Duration(days: 4)), 'Home planning'),
          _CalendarEvent(month.add(const Duration(days: 12)), 'Wellness block'),
          _CalendarEvent(month.add(const Duration(days: 22)), 'Family time'),
        ],
    };

    final today = DateTime.now();
    events.add(_CalendarEvent(_dateOnly(today), '${profile.key} focus'));

    return events.fold(<DateTime, List<_CalendarEvent>>{}, (map, event) {
      final key = _dateOnly(event.date);
      map.putIfAbsent(key, () => []).add(event);
      return map;
    });
  }

  List<_CalendarEvent> _eventsForDay(
    Map<DateTime, List<_CalendarEvent>> events,
    DateTime day,
  ) {
    return events[_dateOnly(day)] ?? const [];
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final ProfileBranding branding;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const _CalendarHeader({
    required this.focusedDay,
    required this.branding,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final monthName = _monthNames[focusedDay.month - 1];

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: branding.cellBorderRadius,
            gradient: branding.monochrome
                ? null
                : LinearGradient(colors: branding.accentGradient),
            color: branding.monochrome ? branding.headerColor : null,
          ),
          child: Icon(
            Icons.calendar_month,
            color: _bestForegroundFor(branding.headerColor),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Workspace Calendar',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: branding.primaryTextColor,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                '$monthName ${focusedDay.year}',
                style: TextStyle(color: branding.secondaryTextColor),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Previous month',
          onPressed: onPreviousMonth,
          icon: const Icon(Icons.chevron_left),
          color: branding.primaryTextColor,
        ),
        IconButton(
          tooltip: 'Next month',
          onPressed: onNextMonth,
          icon: const Icon(Icons.chevron_right),
          color: branding.primaryTextColor,
        ),
      ],
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  final DateTime day;
  final ProfileBranding branding;
  final List<_CalendarEvent> events;

  const _CalendarDayCell({
    required this.day,
    required this.branding,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final scale = branding.dynamicScaling && events.isNotEmpty ? 1.08 : 1.0;

    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      scale: scale,
      child: Container(
        margin: EdgeInsets.all(branding.monochrome ? 2 : 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: events.isEmpty
              ? Colors.transparent
              : branding.markerColor.withValues(
                  alpha: branding.monochrome ? 0.08 : 0.12,
                ),
          borderRadius: branding.cellBorderRadius,
          border: branding.monochrome && events.isNotEmpty
              ? Border.all(color: branding.markerColor.withValues(alpha: 0.35))
              : null,
        ),
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: branding.primaryTextColor,
            fontWeight: events.isEmpty ? FontWeight.w500 : FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _CalendarMarkers extends StatelessWidget {
  final List<_CalendarEvent> events;
  final ProfileBranding branding;

  const _CalendarMarkers({
    required this.events,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    final visibleEvents = events.take(3).toList();

    return Positioned(
      bottom: branding.dynamicScaling ? 5 : 4,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: visibleEvents.map((event) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: branding.dynamicScaling ? 7 : 5,
            height: branding.dynamicScaling ? 7 : 5,
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
              color: branding.markerColor,
              shape: branding.markerShape,
              borderRadius: branding.markerShape == BoxShape.rectangle
                  ? BorderRadius.circular(branding.monochrome ? 0 : 2)
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SelectedDayAgenda extends StatelessWidget {
  final List<_CalendarEvent> events;
  final ProfileBranding branding;

  const _SelectedDayAgenda({
    required this.events,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    final visibleEvents = events.isEmpty
        ? [_CalendarEvent.empty('No scheduled workspace events')]
        : events;

    return Column(
      children: visibleEvents.map((event) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: branding.backgroundColor.withValues(alpha: 0.72),
            borderRadius: branding.cellBorderRadius,
            border: Border.all(
              color: branding.markerColor.withValues(
                alpha: events.isEmpty ? 0.12 : 0.28,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: branding.dynamicScaling ? 12 : 10,
                height: branding.dynamicScaling ? 12 : 10,
                decoration: BoxDecoration(
                  color: events.isEmpty
                      ? branding.secondaryTextColor
                      : branding.markerColor,
                  shape: branding.markerShape,
                  borderRadius: branding.markerShape == BoxShape.rectangle
                      ? BorderRadius.circular(branding.monochrome ? 0 : 2)
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    color: events.isEmpty
                        ? branding.secondaryTextColor
                        : branding.primaryTextColor,
                    fontWeight:
                        events.isEmpty ? FontWeight.w500 : FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _CalendarEvent {
  final DateTime date;
  final String title;

  const _CalendarEvent(this.date, this.title);

  _CalendarEvent.empty(this.title) : date = DateTime(0);
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

Color _bestForegroundFor(Color color) {
  return color.computeLuminance() > 0.45 ? Colors.black87 : Colors.white;
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

class _ProfileSummary extends StatelessWidget {
  final WorkspaceProfile profile;
  final ProfileBranding branding;

  const _ProfileSummary({
    required this.profile,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: branding.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: branding.headerColor.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${profile.key} workspace',
            style: textTheme.titleMedium?.copyWith(
              color: branding.primaryTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(colors: branding.accentGradient),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _BrandChip(
                label: branding.monochrome ? 'Monochrome' : 'Color theme',
                color: branding.markerColor,
              ),
              _BrandChip(
                label: branding.dynamicScaling
                    ? 'Dynamic scaling'
                    : 'Fixed scaling',
                color: branding.todayColor,
              ),
              _BrandChip(
                label: branding.markerShape == BoxShape.circle
                    ? 'Circle markers'
                    : 'Square markers',
                color: branding.selectedDayColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureStatusPanel extends StatelessWidget {
  final ProfileBranding branding;

  const _FeatureStatusPanel({required this.branding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: branding.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: branding.headerColor.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enabled Features',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: branding.primaryTextColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          _FeatureStatusRow(
            icon: Icons.swap_horiz,
            label: 'Profile switching',
            enabled: FeatureFlags.enableProfileSwitching,
            branding: branding,
          ),
          _FeatureStatusRow(
            icon: Icons.calendar_month,
            label: 'Calendar integration',
            enabled: FeatureFlags.enableCalendarIntegration,
            branding: branding,
          ),
          _FeatureStatusRow(
            icon: Icons.cloud_off,
            label: 'Offline mode',
            enabled: FeatureFlags.enableOfflineMode,
            branding: branding,
          ),
          _FeatureStatusRow(
            icon: Icons.public,
            label: 'Global events',
            enabled: FeatureFlags.enableGlobalEvents,
            branding: branding,
          ),
        ],
      ),
    );
  }
}

class _FeatureStatusRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final ProfileBranding branding;

  const _FeatureStatusRow({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: enabled ? branding.markerColor : branding.secondaryTextColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: branding.primaryTextColor),
            ),
          ),
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: enabled ? branding.markerColor : branding.secondaryTextColor,
          ),
        ],
      ),
    );
  }
}

class _BrandChip extends StatelessWidget {
  final String label;
  final Color color;

  const _BrandChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(backgroundColor: color),
      label: Text(label),
    );
  }
}
