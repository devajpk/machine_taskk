import 'package:flutter/material.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';

const _themeTransition = Duration(milliseconds: 280);
const _themeCurve = Curves.easeOutCubic;

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final ProfileBranding branding;

  const SectionHeader({
    required this.icon,
    required this.label,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
          color: branding.primaryTextColor,
          fontWeight: FontWeight.w800,
        );
    final style = branding.monochrome
        ? baseStyle.copyWith(
            fontSize: 14,
            letterSpacing: 1.1,
          )
        : baseStyle;

    return Row(
      children: [
        Icon(icon, size: 18, color: branding.markerColor),
        const SizedBox(width: 8),
        AnimatedDefaultTextStyle(
          duration: _themeTransition,
          curve: _themeCurve,
          style: style,
          child: Text(
            branding.monochrome ? label.toUpperCase() : label,
          ),
        ),
      ],
    );
  }
}
