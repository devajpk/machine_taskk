part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTodosEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final Todo todo;
  AddTodoEvent(this.todo);

  @override
  List<Object?> get props => [todo];
}

class DeleteTodoEvent extends TodoEvent {
  final String id;
  DeleteTodoEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleTodoEvent extends TodoEvent {
  final Todo todo;
  ToggleTodoEvent(this.todo);

  @override
  List<Object?> get props => [todo];
}
