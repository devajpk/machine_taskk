import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_taskk/core/config/app_config.dart';
import 'package:machine_taskk/features/dashboard/domain/usecases/calendar_activity_use_cases.dart';
import 'package:machine_taskk/features/dashboard/presentation/bloc/calendar_activity_bloc.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/animation_app_bar.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/profile_hero_card.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/quick_action.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/section_app_bar.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/work_space_calendar_card.dart';
import 'package:machine_taskk/features/global_events/domain/repo/repo.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';
import 'package:machine_taskk/features/profiles/presentation/bloc/profile_bloc.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_switcher.dart';
import 'package:machine_taskk/features/todos/domain/repo/todo_repositories.dart';
import 'package:machine_taskk/injection/injection.dart';

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

        return BlocProvider(
          create: (_) => CalendarActivityBloc(
            todoRepository: getIt<TodoRepository>(),
            globalEventRepository: getIt<GlobalEventRepository>(),
            useCases: CalendarActivityUseCases(),
          ),
          child: Builder(
            builder: (context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AnimatedDashboardAppBar(
                  profile: profile,
                  branding: branding,
                ),
                body: AnimatedContainer(
                  duration: _themeTransition,
                  curve: _themeCurve,
                  decoration: BoxDecoration(
                    color:
                        branding.monochrome ? branding.backgroundColor : null,
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
                          WorkspaceCalendar(
                            profile: profile,
                            branding: branding,
                          ),
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
                              onPressed: () async {
                                final calendarBloc =
                                    context.read<CalendarActivityBloc>();
                                await GoRouter.of(context).push('/todos');
                                calendarBloc.add(
                                  RefreshCalendarActivitiesEvent(profile),
                                );
                              },
                            ),
                            QuickAction(
                              icon: Icons.public_rounded,
                              label: 'Global Events',
                              subtitle: FeatureFlags.enableGlobalEvents
                                  ? 'Cross-workspace calendar'
                                  : 'Unlocks with a feature flag',
                              onPressed: FeatureFlags.enableGlobalEvents
                                  ? () async {
                                      final calendarBloc =
                                          context.read<CalendarActivityBloc>();
                                      await GoRouter.of(context)
                                          .push('/events');
                                      calendarBloc.add(
                                        RefreshCalendarActivitiesEvent(
                                          profile,
                                        ),
                                      );
                                    }
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
          ),
        );
      },
    );
  }
}
