import 'package:flutter/material.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';

class EmptyCalendarState extends StatelessWidget {
  final ProfileBranding branding;

  const EmptyCalendarState({
    super.key,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: branding.backgroundColor.withValues(alpha: 0.55),
        borderRadius: branding.cellBorderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_available_rounded,
            color: branding.secondaryTextColor.withValues(alpha: 0.78),
            size: 36,
          ),
          const SizedBox(height: 12),
          Text(
            'No activities for this day',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: branding.primaryTextColor,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a Todo or choose another date.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: branding.secondaryTextColor,
              fontWeight: FontWeight.w500,
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
