class GlobalEvent {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime eventDate;

  GlobalEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.eventDate,
  });

  GlobalEvent copyWith({
    int? id,
    String? title,
    String? description,
    String? imageUrl,
    DateTime? eventDate,
  }) {
    return GlobalEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      eventDate: eventDate ?? this.eventDate,
    );
  }

  @override
  String toString() {
    return 'GlobalEvent(id: $id, title: $title, imageUrl: $imageUrl, eventDate: $eventDate)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlobalEvent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          imageUrl == other.imageUrl &&
          eventDate == other.eventDate;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ imageUrl.hashCode ^ eventDate.hashCode;
}
