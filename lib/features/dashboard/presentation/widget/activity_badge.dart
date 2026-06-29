import 'package:flutter/material.dart';

class ActivityBadge extends StatelessWidget {
  final int count;
  final Color color;
  final IconData icon;
  final String semanticLabel;

  const ActivityBadge({
    super.key,
    required this.count,
    required this.color,
    required this.icon,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Semantics(
      label: '$count $semanticLabel',
      child: Container(
        constraints: const BoxConstraints(minWidth: 18, minHeight: 14),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 8, color: Colors.white),
            if (count > 1) ...[
              const SizedBox(width: 2),
              Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
