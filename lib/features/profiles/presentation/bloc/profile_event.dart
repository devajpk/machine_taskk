part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class SwitchProfileEvent extends ProfileEvent {
  final WorkspaceProfile profile;
  SwitchProfileEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}
