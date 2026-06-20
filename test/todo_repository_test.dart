import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:machine_taskk/features/todos/data/todo_repository_impl.dart';
import 'package:machine_taskk/features/todos/domain/entities/todo.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  group('TodoRepository', () {
    final repo = TodoRepositoryImpl();

    test('add, get, delete todo', () async {
      final profile = WorkspaceProfile.personal;
      final todo = Todo(id: 't1', title: 'Test todo');
      await repo.addTodo(profile, todo);
      final list = await repo.getTodos(profile);
      expect(list.any((t) => t.id == 't1'), true);
      await repo.deleteTodo(profile, 't1');
      final after = await repo.getTodos(profile);
      expect(after.any((t) => t.id == 't1'), false);
    });
  });
}
