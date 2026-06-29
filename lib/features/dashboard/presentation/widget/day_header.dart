import 'package:flutter/material.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';

class DayHeader extends StatelessWidget {
  final DateTime selectedDay;
  final int todoCount;
  final int eventCount;
  final ProfileBranding branding;

  const DayHeader({
    super.key,
    required this.selectedDay,
    required this.todoCount,
    required this.eventCount,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    final dateLabel = _dateLabel(selectedDay);
    final countLabel = _countLabel();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: branding.primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                countLabel,
                style: TextStyle(
                  color: branding.secondaryTextColor,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);

    if (selected == today) return 'Today';
    if (selected == today.add(const Duration(days: 1))) return 'Tomorrow';
    if (selected == today.subtract(const Duration(days: 1))) return 'Yesterday';

    return '${_weekdayNames[date.weekday - 1]}, ${_monthNames[date.month - 1]} ${date.day}';
  }

  String _countLabel() {
    final total = todoCount + eventCount;
    if (total == 0) return 'No activities scheduled';

    final todoLabel = todoCount == 1 ? '1 todo' : '$todoCount todos';
    final eventLabel = eventCount == 1 ? '1 event' : '$eventCount events';
    return '$todoLabel | $eventLabel';
  }
}

const _weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

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
