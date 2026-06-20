import 'package:machine_taskk/features/global_events/data/global_event_service.dart';
import 'package:machine_taskk/features/global_events/domain/entities/global_event.dart';

abstract class GlobalEventRepository {
  Future<List<GlobalEvent>> getEvents();
}

class GlobalEventRepositoryImpl implements GlobalEventRepository {
  final GlobalEventService service;

  GlobalEventRepositoryImpl(this.service);

  @override
  Future<List<GlobalEvent>> getEvents() => service.fetchEvents();
}
