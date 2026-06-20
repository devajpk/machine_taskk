import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/workspace_profile.dart';
import '../../data/profile_repository_impl.dart';

import '../../../../core/analytics/analytics_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
final ProfileRepository repository;
final AnalyticsService analyticsService;

ProfileBloc(
this.repository,
this.analyticsService,
) : super(ProfileInitial()) {
on<LoadProfileEvent>(_onLoadProfile);
on<SwitchProfileEvent>(_onSwitchProfile);
}

Future<void> _onLoadProfile(
LoadProfileEvent event,
Emitter<ProfileState> emit,
) async {
try {
emit(ProfileLoading());


  final profile =
      await repository.getCurrentProfile();

  emit(
    ProfileLoaded(profile),
  );
} catch (e) {
  emit(
    ProfileError(
      e.toString(),
    ),
  );
}


}

Future<void> _onSwitchProfile(
SwitchProfileEvent event,
Emitter<ProfileState> emit,
) async {
try {
emit(ProfileLoading());


  final previousProfile =
      await repository.getCurrentProfile();

  await repository.saveProfile(
    event.profile,
  );

  await analyticsService.logProfileSwapped(
    fromProfile: previousProfile.name,
    toProfile: event.profile.name,
  );

  emit(
    ProfileLoaded(
      event.profile,
    ),
  );
} catch (e) {
  emit(
    ProfileError(
      e.toString(),
    ),
  );
}


}
}
