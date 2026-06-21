import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:machine_taskk/features/global_events/domain/entities/global_event.dart';
import 'package:machine_taskk/features/global_events/domain/repo/repo.dart';

part 'global_event_event.dart';
part 'global_event_state.dart';

class GlobalEventBloc extends Bloc<GlobalEventEvent, GlobalEventState> {
  final GlobalEventRepository repository;

  GlobalEventBloc(this.repository) : super(GlobalEventInitial()) {
    on<LoadGlobalEventsEvent>((event, emit) async {
      emit(GlobalEventLoading());
      try {
        final events = await repository.getEvents();
        
        emit(GlobalEventLoaded(events));
      } catch (e) {
        emit(GlobalEventError(e.toString()));
      }
    });

    on<RefreshGlobalEventsEvent>((event, emit) async {
      try {
        final events = await repository.getEvents();
        emit(GlobalEventLoaded(events));
      } catch (e) {
        emit(GlobalEventError(e.toString()));
      }
    });
  }
}
