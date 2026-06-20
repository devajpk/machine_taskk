import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/workspace_profile.dart';
import '../../data/profile_repository_impl.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<LoadProfileEvent>((e, emit) async {
      emit(ProfileLoading());
      final profile = await repository.getCurrentProfile();
      emit(ProfileLoaded(profile));
    });

    on<SwitchProfileEvent>((e, emit) async {
      emit(ProfileLoading());
      await repository.saveProfile(e.profile);
      emit(ProfileLoaded(e.profile));
    });
  }
}
