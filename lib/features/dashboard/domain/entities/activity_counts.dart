class ActivityCounts {
  final int todoCount;
  final int eventCount;

  const ActivityCounts({
    this.todoCount = 0,
    this.eventCount = 0,
  });

  bool get hasTodos => todoCount > 0;
  bool get hasEvents => eventCount > 0;
  bool get hasActivities => hasTodos || hasEvents;

  ActivityCounts copyWith({
    int? todoCount,
    int? eventCount,
  }) {
    return ActivityCounts(
      todoCount: todoCount ?? this.todoCount,
      eventCount: eventCount ?? this.eventCount,
    );
  }
}
