import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/todo.dart';
import '../../profiles/domain/entities/workspace_profile.dart';
import 'package:uuid/uuid.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos(WorkspaceProfile profile);
  Future<void> addTodo(WorkspaceProfile profile, Todo todo);
  Future<void> deleteTodo(WorkspaceProfile profile, String id);
  Future<void> updateTodo(WorkspaceProfile profile, Todo todo);
}

class TodoRepositoryImpl implements TodoRepository {
  final _uuid = Uuid();

  String _boxNameFor(WorkspaceProfile profile) => '${profile.key}_todos';

  Future<Box> _openBox(String name) async => await Hive.openBox(name);

  @override
  Future<void> addTodo(WorkspaceProfile profile, Todo todo) async {
    final box = await _openBox(_boxNameFor(profile));
    final id = todo.id.isEmpty ? _uuid.v4() : todo.id;
    await box.put(id, todo.toMap());
  }

  @override
  Future<void> deleteTodo(WorkspaceProfile profile, String id) async {
    final box = await _openBox(_boxNameFor(profile));
    await box.delete(id);
  }

  @override
  Future<List<Todo>> getTodos(WorkspaceProfile profile) async {
    final box = await _openBox(_boxNameFor(profile));
    final list = box.values.map((e) => Todo.fromMap(Map<String, dynamic>.from(e))).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<void> updateTodo(WorkspaceProfile profile, Todo todo) async {
    final box = await _openBox(_boxNameFor(profile));
    await box.put(todo.id, todo.toMap());
  }
}
