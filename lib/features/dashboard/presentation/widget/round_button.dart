import 'package:flutter/material.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final ProfileBranding branding;

  const RoundIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    final isCircle = branding.markerShape == BoxShape.circle;

    return Material(
      color: branding.markerColor
          .withValues(alpha: branding.monochrome ? 0.08 : 0.1),
      shape: isCircle
          ? const CircleBorder()
          : RoundedRectangleBorder(borderRadius: branding.cellBorderRadius),
      child: InkWell(
        onTap: onPressed,
        customBorder: isCircle
            ? const CircleBorder()
            : RoundedRectangleBorder(borderRadius: branding.cellBorderRadius),
        child: Tooltip(
          message: tooltip,
          child: SizedBox(
            width: 34,
            height: 34,
            child: Icon(icon, size: 20, color: branding.primaryTextColor),
          ),
        ),
      ),
    );
  }
}