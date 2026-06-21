import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';
import 'package:machine_taskk/features/todos/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos(WorkspaceProfile profile);
  Future<void> addTodo(WorkspaceProfile profile, Todo todo);
  Future<void> deleteTodo(WorkspaceProfile profile, String id);
  Future<void> updateTodo(WorkspaceProfile profile, Todo todo);
}