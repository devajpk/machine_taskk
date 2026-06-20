part of 'global_event_bloc.dart';

abstract class GlobalEventState extends Equatable {
  const GlobalEventState();

  @override
  List<Object?> get props => [];
}

class GlobalEventInitial extends GlobalEventState {
  const GlobalEventInitial();
}

class GlobalEventLoading extends GlobalEventState {
  const GlobalEventLoading();
}

class GlobalEventLoaded extends GlobalEventState {
  final List<GlobalEvent> events;

  const GlobalEventLoaded(this.events);

  @override
  List<Object?> get props => [events];
}

class GlobalEventError extends GlobalEventState {
  final String message;

  const GlobalEventError(this.message);

  @override
  List<Object?> get props => [message];
}
