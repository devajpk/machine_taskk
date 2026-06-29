import 'package:flutter/material.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';

enum ActivityTileType { todo, event }

class ActivityTile extends StatelessWidget {
  final String title;
  final DateTime date;
  final ActivityTileType type;
  final bool completed;
  final ProfileBranding branding;

  const ActivityTile({
    super.key,
    required this.title,
    required this.date,
    required this.type,
    required this.branding,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = type == ActivityTileType.todo
        ? const Color(0xFF2563EB)
        : const Color(0xFF16A34A);
    final icon = type == ActivityTileType.todo
        ? (completed
            ? Icons.check_circle_rounded
            : Icons.radio_button_unchecked)
        : Icons.event_rounded;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: branding.backgroundColor.withValues(alpha: 0.55),
        borderRadius: branding.cellBorderRadius,
      ),
      child: Row(
        children: [
          Icon(icon, color: accent, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: completed
                    ? branding.secondaryTextColor
                    : branding.primaryTextColor,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                decoration: completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _timeLabel(date),
            style: TextStyle(
              color: branding.secondaryTextColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _timeLabel(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
