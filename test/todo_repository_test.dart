import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:machine_taskk/features/todos/data/repo_imp/todo_repository_impl.dart';
import 'package:machine_taskk/features/todos/domain/entities/todo.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory hiveDirectory;

  setUp(() async {
    hiveDirectory = await Directory.systemTemp.createTemp('todo_hive_test_');
    Hive.init(hiveDirectory.path);
  });

  tearDown(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  group('TodoRepository', () {
    test('add, get, delete todo', () async {
      final repo = TodoRepositoryImpl();
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
