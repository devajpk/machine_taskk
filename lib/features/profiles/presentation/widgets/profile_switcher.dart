import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile_bloc.dart';
import '../../domain/entities/workspace_profile.dart';

class ProfileSwitcher extends StatelessWidget {
  const ProfileSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final current = state.profile;

          return SizedBox(
            height: 48,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: WorkspaceProfile.values.map((profile) {
                  final selected = profile == current;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(profile.key),
                      selected: selected,
                      showCheckmark: true,
                      onSelected: (_) {
                        if (!selected) {
                          context
                              .read<ProfileBloc>()
                              .add(SwitchProfileEvent(profile));
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }

        if (state is ProfileLoading) {
          return const SizedBox(
            height: 48,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}