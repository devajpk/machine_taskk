import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/todo_bloc.dart';
import '../../data/todo_repository_impl.dart';
import '../../domain/entities/todo.dart';

import 'package:uuid/uuid.dart';

class TodosPage extends StatelessWidget {
  final _uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileBloc>().state;
    WorkspaceProfile profile = WorkspaceProfile.personal;
    if (profileState is ProfileLoaded) profile = profileState.profile;

    return BlocProvider(
      create: (_) =>
          TodoBloc(repository: TodoRepositoryImpl(), profile: profile)
            ..add(LoadTodosEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Todos')),
        body: Column(
          children: [
            Expanded(child:
                BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
              if (state is TodoLoading)
                return const Center(child: CircularProgressIndicator());
              if (state is TodoLoaded) {
                final todos = state.todos;
                if (todos.isEmpty) return const Center(child: Text('No todos'));
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final t = todos[index];
                    return ListTile(
                      title: Text(t.title),
                      leading: Checkbox(
                          value: t.isCompleted,
                          onChanged: (_) =>
                              context.read<TodoBloc>().add(ToggleTodoEvent(t))),
                      trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => context
                              .read<TodoBloc>()
                              .add(DeleteTodoEvent(t.id))),
                    );
                  },
                );
              }
              if (state is TodoError) return Center(child: Text(state.message));
              return const SizedBox.shrink();
            })),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: _AddTodoField()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _AddTodoField extends StatefulWidget {
  @override
  State<_AddTodoField> createState() => _AddTodoFieldState();
}

class _AddTodoFieldState extends State<_AddTodoField> {
  final _controller = TextEditingController();
  final _uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Add todo'))),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            final text = _controller.text.trim();
            if (text.isEmpty) return;
            final todo = Todo(id: _uuid.v4(), title: text);
            context.read<TodoBloc>().add(AddTodoEvent(todo));
            _controller.clear();
          },
        )
      ],
    );
  }
}
