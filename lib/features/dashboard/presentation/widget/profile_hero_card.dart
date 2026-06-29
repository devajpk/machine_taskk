import 'package:flutter/material.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/quick_action.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/trait_bill_widget.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';

const _themeTransition = Duration(milliseconds: 280);
const _themeCurve = Curves.easeOutCubic;

class ProfileHeroCard extends StatelessWidget {
  final WorkspaceProfile profile;
  final ProfileBranding branding;

  const ProfileHeroCard({
    required this.profile,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    final onHero = _bestForegroundFor(branding.headerColor);

    return AnimatedContainer(
      duration: _themeTransition,
      curve: _themeCurve,
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: branding.monochrome ? branding.headerColor : null,
        gradient: branding.monochrome
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: branding.accentGradient,
              ),
        borderRadius: branding.cellBorderRadius,
        boxShadow: branding.monochrome
            ? null
            : [
                BoxShadow(
                  color: branding.headerColor.withValues(alpha: 0.28),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: _themeTransition,
                curve: _themeCurve,
                width: 52,
                height: 52,
                // Same rule as the appbar badge: explicit borderRadius only,
                // never combined with a shape enum.
                decoration: BoxDecoration(
                  color: onHero.withValues(alpha: 0.16),
                  borderRadius: branding.cellBorderRadius,
                ),
                child: Icon(Icons.workspaces_outlined, color: onHero, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: _themeTransition,
                      curve: _themeCurve,
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: onHero,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                      child: Text('${profile.key} Workspace'),
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: _themeTransition,
                      curve: _themeCurve,
                      style: TextStyle(
                        color: onHero.withValues(alpha: 0.82),
                        fontSize: 13,
                      ),
                      child: const Text(
                        'Layout, color and motion tuned to this profile',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TraitPill(
                label: branding.monochrome ? 'Structured' : 'Creative',
                color: onHero,
              ),
              TraitPill(
                label: branding.dynamicScaling ? 'Adaptive' : 'Static',
                color: onHero,
              ),
              TraitPill(
                label: branding.markerShape == BoxShape.circle
                    ? 'Organic'
                    : 'Geometric',
                color: onHero,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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

Color _bestForegroundFor(Color color) {
  return color.computeLuminance() > 0.45 ? Colors.black87 : Colors.white;
}
