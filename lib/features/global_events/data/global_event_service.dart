import 'package:flutter/foundation.dart';
import 'package:machine_taskk/core/network/network_info.dart';
import 'package:machine_taskk/core/network/network_service.dart';
import 'package:machine_taskk/features/global_events/domain/entities/global_event.dart';

class GlobalEventService {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  GlobalEventService(
    this.networkService,
    this.networkInfo,
  );

  /// Fetch photos from JSONPlaceholder and convert them into GlobalEvents
  Future<List<GlobalEvent>> fetchEvents({
    int limit = 10,
  }) async {
    final connected = await networkInfo.isConnected;

    if (!connected) {
      throw Exception('No internet connection');
    }

    final response = await networkService.get(
      '/photos',
      queryParameters: {
        '_limit': limit,
      },
    );

    debugPrint('=================================');
    debugPrint('API Response Status: ${response.statusCode}');
    debugPrint('=================================');

    final photos = response.data as List<dynamic>;

    return photos.asMap().entries.map((entry) {
      final index = entry.key;
      final photo = entry.value as Map<String, dynamic>;

      final int photoId = photo['id'] as int? ?? 0;

      /// JSONPlaceholder returns URLs from via.placeholder.com
      /// which currently fails SSL handshakes on many networks.
      /// We replace them with stable Picsum images.
      final String imageUrl =
          'https://picsum.photos/seed/$photoId/600/600';

      debugPrint('---------------------------------');
      debugPrint('Event ID: $photoId');
      debugPrint('Original URL: ${photo['url']}');
      debugPrint('Using URL: $imageUrl');
      debugPrint('---------------------------------');

      return GlobalEvent(
        id: photoId,
        title: photo['title'] as String? ?? 'Event ${index + 1}',
        description:
            'A global event from the photo collection. Photo ID: $photoId',
        imageUrl: imageUrl,
        eventDate: DateTime.now().add(
          Duration(days: index + 1),
        ),
      );
    }).toList();
  }
}