import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_taskk/core/config/app_config.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/animation_app_bar.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/profile_hero_card.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/quick_action.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/section_app_bar.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/work_space_calendar_card.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';
import 'package:machine_taskk/features/profiles/presentation/bloc/profile_bloc.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_switcher.dart';


const _themeTransition = Duration(milliseconds: 280);
const _themeCurve = Curves.easeOutCubic;

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profile =
            state is ProfileLoaded ? state.profile : WorkspaceProfile.personal;
        final branding = profile.branding;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AnimatedDashboardAppBar(profile: profile, branding: branding),
          body: AnimatedContainer(
            duration: _themeTransition,
            curve: _themeCurve,
            decoration: BoxDecoration(
              color: branding.monochrome ? branding.backgroundColor : null,
              gradient: branding.monochrome
                  ? null
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        branding.backgroundColor,
                        Color.lerp(
                          branding.backgroundColor,
                          branding.headerColor,
                          0.05,
                        )!,
                      ],
                    ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfileSwitcher(),
                  const SizedBox(height: 20),
                  ProfileHeroCard(profile: profile, branding: branding),
                  if (FeatureFlags.enableCalendarIntegration) ...[
                    const SizedBox(height: 24),
                    WorkspaceCalendar(profile: profile, branding: branding),
                  ],
                  const SizedBox(height: 28),
                  SectionHeader(
                    icon: Icons.bolt_rounded,
                    label: 'Quick Actions',
                    branding: branding,
                  ),
                  const SizedBox(height: 14),
                  QuickActionsGrid(
                    branding: branding,
                    actions: [
                      QuickAction(
                        icon: Icons.checklist_rounded,
                        label: 'My Todos',
                        subtitle: 'Your personal task list',
                        onPressed: () => GoRouter.of(context).push('/todos'),
                      ),
                      QuickAction(
                        icon: Icons.public_rounded,
                        label: 'Global Events',
                        subtitle: FeatureFlags.enableGlobalEvents
                            ? 'Cross-workspace calendar'
                            : 'Unlocks with a feature flag',
                        onPressed: FeatureFlags.enableGlobalEvents
                            ? () => GoRouter.of(context).push('/events')
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SectionHeader(
                    icon: Icons.tune_rounded,
                    label: 'Enabled Features',
                    branding: branding,
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CalendarDayCell extends StatelessWidget {
  final DateTime day;
  final ProfileBranding branding;
  final List<CalendarEvent> events;

  const CalendarDayCell({
    super.key,
    required this.day,
    required this.branding,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final scale = branding.dynamicScaling && events.isNotEmpty ? 1.08 : 1.0;

    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      scale: scale,
      child: AnimatedContainer(
        duration: _themeTransition,
        curve: _themeCurve,
        margin: EdgeInsets.all(branding.monochrome ? 2 : 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: events.isEmpty
              ? Colors.transparent
              : branding.markerColor.withValues(
                  alpha: branding.monochrome ? 0.08 : 0.12,
                ),
          borderRadius: branding.cellBorderRadius,
          border: branding.monochrome && events.isNotEmpty
              ? Border.all(color: branding.markerColor.withValues(alpha: 0.35))
              : null,
        ),
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: branding.primaryTextColor,
            fontWeight: events.isEmpty ? FontWeight.w500 : FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class CalendarMarkers extends StatelessWidget {
  final List<CalendarEvent> events;
  final ProfileBranding branding;

  const CalendarMarkers({
    super.key,
    required this.events,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    final visibleEvents = events.take(3).toList();
    final isCircle = branding.markerShape == BoxShape.circle;

    return Positioned(
      bottom: branding.dynamicScaling ? 5 : 4,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: visibleEvents.map((event) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: branding.dynamicScaling ? 7 : 5,
            height: branding.dynamicScaling ? 7 : 5,
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: isCircle
                ? BoxDecoration(
                    color: branding.markerColor,
                    shape: BoxShape.circle,
                  )
                : BoxDecoration(
                    color: branding.markerColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(
                      branding.monochrome ? 0 : 2,
                    ),
                  ),
          );
        }).toList(),
      ),
    );
  }
}

class SelectedDayAgenda extends StatelessWidget {
  final List<CalendarEvent> events;
  final ProfileBranding branding;

  const SelectedDayAgenda({
    super.key,
    required this.events,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    final visibleEvents = events.isEmpty
        ? [CalendarEvent.empty('No scheduled workspace events')]
        : events;

    return Column(
      children: visibleEvents.map((event) {
        return AnimatedContainer(
          duration: _themeTransition,
          curve: _themeCurve,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: branding.backgroundColor.withValues(alpha: 0.6),
            borderRadius: branding.cellBorderRadius,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: _themeTransition,
                curve: _themeCurve,
                width: 4,
                height: 30,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: events.isEmpty
                      ? branding.secondaryTextColor.withValues(alpha: 0.4)
                      : branding.markerColor,
                  borderRadius:
                      BorderRadius.circular(branding.monochrome ? 0 : 3),
                ),
              ),
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    color: events.isEmpty
                        ? branding.secondaryTextColor
                        : branding.primaryTextColor,
                    fontWeight:
                        events.isEmpty ? FontWeight.w500 : FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class CalendarEvent {
  final DateTime date;
  final String title;

  const CalendarEvent(this.date, this.title);

  CalendarEvent.empty(this.title) : date = DateTime(0);
}




