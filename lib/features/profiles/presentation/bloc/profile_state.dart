part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final WorkspaceProfile profile;
  ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}
