class Todo {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;

  Todo({required this.id, required this.title, this.isCompleted = false, DateTime? createdAt}) : createdAt = createdAt ?? DateTime.now();

  Todo copyWith({String? id, String? title, bool? isCompleted, DateTime? createdAt}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Todo.fromMap(Map<String, dynamic> map) => Todo(
        id: map['id'] as String,
        title: map['title'] as String,
        isCompleted: map['isCompleted'] as bool,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}
