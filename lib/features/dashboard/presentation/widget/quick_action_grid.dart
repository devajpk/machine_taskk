import 'package:flutter/material.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/quick_action.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';

const _themeTransition = Duration(milliseconds: 280);
const _themeCurve = Curves.easeOutCubic;

class QuickActionsGrid extends StatelessWidget {
  final ProfileBranding branding;
  final List<QuickAction> actions;

  const QuickActionsGrid({
    required this.branding,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth > 480;
        final itemWidth =
            twoColumns ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: actions
              .map(
                (action) => SizedBox(
                  width: itemWidth,
                  child: QuickActionCard(branding: branding, action: action),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final ProfileBranding branding;
  final QuickAction action;

  const QuickActionCard({required this.branding, required this.action});

  @override
  Widget build(BuildContext context) {
    final isEnabled = action.onPressed != null;

    return AnimatedContainer(
      duration: _themeTransition,
      curve: _themeCurve,
      decoration: BoxDecoration(borderRadius: branding.cellBorderRadius),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: branding.surfaceColor,
        elevation: branding.monochrome ? 0 : 3,
        shadowColor: branding.markerColor.withValues(alpha: 0.25),
        borderRadius: branding.cellBorderRadius,
        child: InkWell(
          onTap: action.onPressed,
          borderRadius: branding.cellBorderRadius,
          child: Opacity(
            opacity: isEnabled ? 1 : 0.5,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: branding.markerColor.withValues(
                        alpha: branding.monochrome ? 0.10 : 0.14,
                      ),
                      borderRadius: branding.cellBorderRadius,
                    ),
                    child: Icon(
                      action.icon,
                      size: 20,
                      color: branding.markerColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          action.label,
                          style: TextStyle(
                            color: branding.primaryTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          action.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: branding.secondaryTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: branding.secondaryTextColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
