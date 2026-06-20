import 'package:dio/dio.dart';
import 'package:machine_taskk/features/global_events/domain/entities/global_event.dart';

class GlobalEventService {
  final Dio dio;

  GlobalEventService(this.dio);

  /// Fetch photos from JSONPlaceholder and convert to GlobalEvents
  Future<List<GlobalEvent>> fetchEvents() async {
    try {
      final response = await dio.get('/photos?_limit=10');
      final photos = response.data as List;

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
    } catch (e) {
      rethrow;
    }
  }
}
