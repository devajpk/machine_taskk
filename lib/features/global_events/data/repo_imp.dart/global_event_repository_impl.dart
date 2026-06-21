import 'package:machine_taskk/features/global_events/data/remote_data_source/remote_data_sorce.dart';
import 'package:machine_taskk/features/global_events/domain/entities/global_event.dart';
import 'package:machine_taskk/features/global_events/domain/repo/repo.dart';



class GlobalEventRepositoryImpl implements GlobalEventRepository {
  final GlobalEventRemoteDataSource service;

  GlobalEventRepositoryImpl(this.service);

  @override
  Future<List<GlobalEvent>> getEvents() => service.fetchEvents();
}
