import 'package:flutter/material.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';
const _themeTransition = Duration(milliseconds: 280);
const _themeCurve = Curves.easeOutCubic;

class AnimatedDashboardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final WorkspaceProfile profile;
  final ProfileBranding branding;

  const AnimatedDashboardAppBar({
    required this.profile,
    required this.branding,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _themeTransition,
      curve: _themeCurve,
      decoration: BoxDecoration(
        color: branding.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: branding.headerColor.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              const SizedBox(width: 16),
              AnimatedContainer(
                duration: _themeTransition,
                curve: _themeCurve,
                width: 36,
                height: 36,
                // Logo mark: only ever a rounded-rect badge. We deliberately
                // do NOT use branding.markerShape here — if it's
                // BoxShape.circle this must NOT also carry a borderRadius,
                // so the badge always uses an explicit BorderRadius instead
                // of the shape enum to avoid the illegal combination.
                decoration: BoxDecoration(
                  borderRadius: branding.cellBorderRadius,
                  gradient: branding.monochrome
                      ? null
                      : LinearGradient(colors: branding.accentGradient),
                  color: branding.monochrome ? branding.headerColor : null,
                ),
                child: Icon(
                  Icons.workspaces_outlined,
                  size: 18,
                  color: _bestForegroundFor(branding.headerColor),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: _themeTransition,
                      curve: _themeCurve,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: branding.primaryTextColor,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                      child: const Text('Workspace Engine'),
                    ),
                    AnimatedDefaultTextStyle(
                      duration: _themeTransition,
                      curve: _themeCurve,
                      style: TextStyle(
                        color: branding.secondaryTextColor,
                        fontSize: 12,
                        height: 1.3,
                      ),
                      child: Text('${profile.key} workspace'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
Color _bestForegroundFor(Color color) {
  return color.computeLuminance() > 0.45 ? Colors.black87 : Colors.white;
}

