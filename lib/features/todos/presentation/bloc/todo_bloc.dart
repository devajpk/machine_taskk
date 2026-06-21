import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';
import 'package:machine_taskk/features/todos/domain/repo/todo_repositories.dart';
import '../../domain/entities/todo.dart';



part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;
  final WorkspaceProfile profile;

  TodoBloc({required this.repository, required this.profile})
      : super(TodoLoading()) {
    on<LoadTodosEvent>((e, emit) async {
      emit(TodoLoading());
      final todos = await repository.getTodos(profile);
      emit(TodoLoaded(todos));
    });

    on<AddTodoEvent>((e, emit) async {
      await repository.addTodo(profile, e.todo);
      add(LoadTodosEvent());
    });

    on<DeleteTodoEvent>((e, emit) async {
      await repository.deleteTodo(profile, e.id);
      add(LoadTodosEvent());
    });

    on<ToggleTodoEvent>((e, emit) async {
      final current = e.todo;
      final updated = current.copyWith(isCompleted: !current.isCompleted);
      await repository.updateTodo(profile, updated);
      add(LoadTodosEvent());
    });
  }
}
