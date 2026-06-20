import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_taskk/core/config/app_config.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';
import 'package:machine_taskk/features/profiles/presentation/bloc/profile_bloc.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_switcher.dart';

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
          backgroundColor: branding.backgroundColor,
          appBar: AppBar(
            title: const Text('Multi Profile Workspace Engine'),
            backgroundColor: branding.surfaceColor,
            foregroundColor: branding.primaryTextColor,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileSwitcher(),
                const SizedBox(height: 24),
                _ProfileSummary(profile: profile, branding: branding),
                const SizedBox(height: 24),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: branding.primaryTextColor,
                      ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => GoRouter.of(context).push('/todos'),
                      icon: const Icon(Icons.list),
                      label: const Text('My Todos'),
                    ),
                    ElevatedButton.icon(
                      onPressed: FeatureFlags.enableGlobalEvents
                          ? () => GoRouter.of(context).push('/events')
                          : null,
                      icon: const Icon(Icons.public),
                      label: const Text('Global Events'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _FeatureStatusPanel(branding: branding),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  final WorkspaceProfile profile;
  final ProfileBranding branding;

  const _ProfileSummary({
    required this.profile,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: branding.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: branding.headerColor.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${profile.key} workspace',
            style: textTheme.titleMedium?.copyWith(
              color: branding.primaryTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(colors: branding.accentGradient),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _BrandChip(
                label: branding.monochrome ? 'Monochrome' : 'Color theme',
                color: branding.markerColor,
              ),
              _BrandChip(
                label: branding.dynamicScaling
                    ? 'Dynamic scaling'
                    : 'Fixed scaling',
                color: branding.todayColor,
              ),
              _BrandChip(
                label: branding.markerShape == BoxShape.circle
                    ? 'Circle markers'
                    : 'Square markers',
                color: branding.selectedDayColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureStatusPanel extends StatelessWidget {
  final ProfileBranding branding;

  const _FeatureStatusPanel({required this.branding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: branding.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: branding.headerColor.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enabled Features',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: branding.primaryTextColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          _FeatureStatusRow(
            icon: Icons.swap_horiz,
            label: 'Profile switching',
            enabled: FeatureFlags.enableProfileSwitching,
            branding: branding,
          ),
          _FeatureStatusRow(
            icon: Icons.calendar_month,
            label: 'Calendar integration',
            enabled: FeatureFlags.enableCalendarIntegration,
            branding: branding,
          ),
          _FeatureStatusRow(
            icon: Icons.cloud_off,
            label: 'Offline mode',
            enabled: FeatureFlags.enableOfflineMode,
            branding: branding,
          ),
          _FeatureStatusRow(
            icon: Icons.public,
            label: 'Global events',
            enabled: FeatureFlags.enableGlobalEvents,
            branding: branding,
          ),
        ],
      ),
    );
  }
}

class _FeatureStatusRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final ProfileBranding branding;

  const _FeatureStatusRow({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: enabled ? branding.markerColor : branding.secondaryTextColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: branding.primaryTextColor),
            ),
          ),
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: enabled ? branding.markerColor : branding.secondaryTextColor,
          ),
        ],
      ),
    );
  }
}

class _BrandChip extends StatelessWidget {
  final String label;
  final Color color;

  const _BrandChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(backgroundColor: color),
      label: Text(label),
    );
  }
}
