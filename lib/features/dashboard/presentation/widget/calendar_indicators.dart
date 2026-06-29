import 'package:flutter/material.dart';
import 'package:machine_taskk/features/dashboard/domain/entities/activity_counts.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/activity_badge.dart';

class CalendarIndicators extends StatelessWidget {
  final ActivityCounts counts;

  const CalendarIndicators({
    super.key,
    required this.counts,
  });

  @override
  Widget build(BuildContext context) {
    if (!counts.hasActivities) return const SizedBox(height: 16);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: Wrap(
        key: ValueKey('${counts.todoCount}-${counts.eventCount}'),
        spacing: 3,
        runSpacing: 2,
        alignment: WrapAlignment.center,
        children: [
          ActivityBadge(
            count: counts.todoCount,
            color: const Color(0xFF2563EB),
            icon: Icons.check_rounded,
            semanticLabel: 'todos',
          ),
          ActivityBadge(
            count: counts.eventCount,
            color: const Color(0xFF16A34A),
            icon: Icons.event_rounded,
            semanticLabel: 'events',
          ),
        ],
      ),
    );
  }
}
