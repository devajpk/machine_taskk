import 'package:machine_taskk/core/network/network_info.dart';
import 'package:machine_taskk/core/network/network_service.dart';
import 'package:machine_taskk/features/global_events/domain/entities/global_event.dart';

class GlobalEventService {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  GlobalEventService(this.networkService, this.networkInfo);

  /// Fetch photos from JSONPlaceholder and convert to GlobalEvents
  Future<List<GlobalEvent>> fetchEvents({int limit = 10}) async {
    // Ensure we have network connectivity before attempting the request
    final connected = await networkInfo.isConnected;
    if (!connected) {
      throw Exception('No internet connection');
    }

    final response =
        await networkService.get('/photos', queryParameters: {'_limit': limit});

    final photos = response.data as List<dynamic>;

    return photos.asMap().entries.map((entry) {
      final index = entry.key;
      final photo = entry.value as Map<String, dynamic>;

      return GlobalEvent(
        id: photo['id'] as int? ?? 0,
        title: photo['title'] as String? ?? 'Event ${index + 1}',
        description:
            'A global event from the photo collection. Photo ID: ${photo['id']}',
        imageUrl: photo['url'] as String? ?? '',
        // Generate event dates spread over the coming weeks
        eventDate: DateTime.now().add(Duration(days: index + 1)),
      );
    }).toList();
  }
}
