import 'package:flutter/material.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';

const _themeTransition = Duration(milliseconds: 280);
const _themeCurve = Curves.easeOutCubic;

class FeatureBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final ProfileBranding branding;

  const FeatureBadge({
    super.key,
    required this.icon,
    required this.label,
    required this.enabled,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    final tint = enabled ? branding.markerColor : branding.secondaryTextColor;

    return AnimatedContainer(
      duration: _themeTransition,
      curve: _themeCurve,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: enabled
            ? branding.markerColor
                .withValues(alpha: branding.monochrome ? 0.08 : 0.12)
            : Colors.transparent,
        border: Border.all(
          color: tint.withValues(alpha: enabled ? 0.4 : 0.25),
        ),
        borderRadius: branding.cellBorderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: tint),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: enabled
                  ? branding.primaryTextColor
                  : branding.secondaryTextColor,
              fontWeight: enabled ? FontWeight.w700 : FontWeight.w500,
              fontSize: 12.5,
            ),
          ),
          if (enabled) ...[
            const SizedBox(width: 6),
            Icon(Icons.check_circle_rounded, size: 13, color: tint),
          ],
        ],
      ),
    );
  }
}
