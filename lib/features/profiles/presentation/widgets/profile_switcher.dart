import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../../domain/entities/workspace_profile.dart';

class ProfileSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state is ProfileLoaded) {
        final current = state.profile;
        return Row(
          children: WorkspaceProfile.values.map((p) {
            final selected = p == current;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(p.key),
                selected: selected,
                onSelected: (sel) {
                  if (sel)
                    context.read<ProfileBloc>().add(SwitchProfileEvent(p));
                },
              ),
            );
          }).toList(),
        );
      }

      if (state is ProfileLoading) return const CircularProgressIndicator();
      return const SizedBox.shrink();
    });
  }
}
