part of 'global_event_bloc.dart';

abstract class GlobalEventEvent extends Equatable {
  const GlobalEventEvent();

  @override
  List<Object?> get props => [];
}

class LoadGlobalEventsEvent extends GlobalEventEvent {
  const LoadGlobalEventsEvent();
}

class RefreshGlobalEventsEvent extends GlobalEventEvent {
  const RefreshGlobalEventsEvent();
}
