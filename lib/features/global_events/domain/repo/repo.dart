import 'package:machine_taskk/features/global_events/domain/entities/global_event.dart';

abstract class GlobalEventRepository {
  Future<List<GlobalEvent>> getEvents();
}
