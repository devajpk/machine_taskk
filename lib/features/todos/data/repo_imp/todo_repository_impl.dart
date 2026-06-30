import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';
import 'package:machine_taskk/features/todos/domain/entities/todo.dart';
import 'package:machine_taskk/features/todos/domain/repo/todo_repositories.dart';
import 'package:uuid/uuid.dart';

class TodoRepositoryImpl implements TodoRepository {
  final _uuid = Uuid();
  final _todoChanges = StreamController<WorkspaceProfile>.broadcast();

  @override
  Stream<WorkspaceProfile> get todoChanges => _todoChanges.stream;

  String _boxNameFor(WorkspaceProfile profile) => '${profile.key}_todos';

  Future<Box> _openBox(String name) async => await Hive.openBox(name);

  void _notifyChanged(WorkspaceProfile profile) {
    if (!_todoChanges.isClosed) {
      _todoChanges.add(profile);
    }
  }

  @override
  Future<void> addTodo(WorkspaceProfile profile, Todo todo) async {
    final box = await _openBox(_boxNameFor(profile));
    final id = todo.id.isEmpty ? _uuid.v4() : todo.id;
    await box.put(id, todo.toMap());
    _notifyChanged(profile);
  }

  @override
  Future<void> deleteTodo(WorkspaceProfile profile, String id) async {
    final box = await _openBox(_boxNameFor(profile));
    await box.delete(id);
    _notifyChanged(profile);
  }

  @override
  Future<List<Todo>> getTodos(WorkspaceProfile profile) async {
    final box = await _openBox(_boxNameFor(profile));
    final list = box.values
        .map((e) => Todo.fromMap(Map<String, dynamic>.from(e)))
        .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<void> updateTodo(WorkspaceProfile profile, Todo todo) async {
    final box = await _openBox(_boxNameFor(profile));
    await box.put(todo.id, todo.toMap());
    _notifyChanged(profile);
  }
}
