import 'package:flutter/material.dart';
import '../../domain/entities/workspace_profile.dart';

class ProfileBranding {
  final Color backgroundColor;
  final Color surfaceColor;
  final Color headerColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color selectedDayColor;
  final Color todayColor;
  final Color markerColor;
  final BorderRadius cellBorderRadius;
  final BoxShape markerShape;
  final bool monochrome;
  final bool dynamicScaling;
  final List<Color> accentGradient;

  const ProfileBranding({
    required this.backgroundColor,
    required this.surfaceColor,
    required this.headerColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.selectedDayColor,
    required this.todayColor,
    required this.markerColor,
    required this.cellBorderRadius,
    required this.markerShape,
    required this.monochrome,
    required this.dynamicScaling,
    required this.accentGradient,
  });
}

extension WorkspaceProfileBranding on WorkspaceProfile {
  ProfileBranding get branding {
    switch (this) {
      case WorkspaceProfile.corporate:
        return ProfileBranding(
          backgroundColor: const Color(0xFFF7F7F7),
          surfaceColor: Colors.white,
          headerColor: const Color(0xFF212121),
          primaryTextColor: Colors.black87,
          secondaryTextColor: Colors.grey,
          selectedDayColor: Colors.black,
          todayColor: Colors.grey.shade800,
          markerColor: Colors.black,
          cellBorderRadius: BorderRadius.zero,
          markerShape: BoxShape.rectangle,
          monochrome: true,
          dynamicScaling: false,
          accentGradient: const [Color(0xFF212121), Color(0xFF616161)],
        );
      case WorkspaceProfile.creative:
        return ProfileBranding(
          backgroundColor: const Color(0xFF100E28),
          surfaceColor: const Color(0xFF2D1E5F),
          headerColor: const Color(0xFF6D3BFF),
          primaryTextColor: Colors.white,
          secondaryTextColor: const Color(0xFFE0B0FF),
          selectedDayColor: const Color(0xFFFFC107),
          todayColor: const Color(0xFF00E5FF),
          markerColor: const Color(0xFFFF4081),
          cellBorderRadius: BorderRadius.circular(20),
          markerShape: BoxShape.circle,
          monochrome: false,
          dynamicScaling: true,
          accentGradient: const [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
        );
      case WorkspaceProfile.work:
        return ProfileBranding(
          backgroundColor: const Color(0xFFE7EBF0),
          surfaceColor: Colors.white,
          headerColor: const Color(0xFF1F3B5D),
          primaryTextColor: const Color(0xFF1F3B5D),
          secondaryTextColor: Colors.blueGrey,
          selectedDayColor: const Color(0xFF1F3B5D),
          todayColor: const Color(0xFF4A90E2),
          markerColor: const Color(0xFF4A90E2),
          cellBorderRadius: BorderRadius.circular(8),
          markerShape: BoxShape.circle,
          monochrome: false,
          dynamicScaling: false,
          accentGradient: const [Color(0xFF4A90E2), Color(0xFF50E3C2)],
        );
      case WorkspaceProfile.personal:
        return ProfileBranding(
          backgroundColor: const Color(0xFFF1F5FB),
          surfaceColor: Colors.white,
          headerColor: const Color(0xFF5060A8),
          primaryTextColor: const Color(0xFF1F2B5C),
          secondaryTextColor: Colors.blueGrey,
          selectedDayColor: const Color(0xFF5060A8),
          todayColor: const Color(0xFF3F8AE0),
          markerColor: const Color(0xFF3F8AE0),
          cellBorderRadius: BorderRadius.circular(12),
          markerShape: BoxShape.circle,
          monochrome: false,
          dynamicScaling: false,
          accentGradient: const [Color(0xFF5060A8), Color(0xFFA8C0FF)],
        );
    }
  }
}
