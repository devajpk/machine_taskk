import 'package:flutter/material.dart';
import 'package:machine_taskk/features/dashboard/domain/entities/activity_counts.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/activity_badge.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';

class CalendarIndicators extends StatelessWidget {
  final ActivityCounts counts;
  final ProfileBranding branding;

  const CalendarIndicators({
    super.key,
    required this.counts,
    required this.branding,
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
            color: branding.markerColor,
            icon: Icons.check_rounded,
            semanticLabel: 'todos',
            borderRadius: branding.cellBorderRadius,
          ),
          ActivityBadge(
            count: counts.eventCount,
            color: branding.markerColor,
            icon: Icons.event_rounded,
            semanticLabel: 'events',
            borderRadius: branding.cellBorderRadius,
          ),
        ],
      ),
    );
  }
}
