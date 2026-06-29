import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';
import 'package:machine_taskk/features/profiles/presentation/bloc/profile_bloc.dart';
import 'package:machine_taskk/features/todos/presentation/widget/add_todo_bar.dart';
import 'package:machine_taskk/features/todos/presentation/widget/colors.dart';
import 'package:machine_taskk/features/todos/presentation/widget/empty_state.dart';
import 'package:machine_taskk/features/todos/presentation/widget/error_state.dart';
import 'package:machine_taskk/features/todos/presentation/widget/header.dart';
import 'package:machine_taskk/features/todos/presentation/widget/todo_row.dart';
import 'package:machine_taskk/injection/injection.dart';
import 'package:machine_taskk/features/todos/domain/repo/todo_repositories.dart';
import '../../presentation/bloc/todo_bloc.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileBloc>().state;
    WorkspaceProfile profile = WorkspaceProfile.personal;
    if (profileState is ProfileLoaded) profile = profileState.profile;

    return BlocProvider(
      create: (_) =>
          TodoBloc(repository: getIt<TodoRepository>(), profile: profile)
            ..add(LoadTodosEvent()),
      child: const _TodosView(),
    );
  }
}

class _TodosView extends StatelessWidget {
  const _TodosView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      body: SafeArea(
        child: Column(
          children: [
            Header(),
            Expanded(
              child: BlocBuilder<TodoBloc, TodoState>(
                builder: (context, state) {
                  if (state is TodoLoading) {
                    return const Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Palette.accent,
                          strokeWidth: 2.4,
                        ),
                      ),
                    );
                  }
                  if (state is TodoError) {
                    return ErrorState(message: state.message);
                  }
                  if (state is TodoLoaded) {
                    final todos = state.todos;
                    if (todos.isEmpty) return const EmptyState();
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 110),
                      itemCount: todos.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: Palette.hairline,
                      ),
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return TodoRow(
                          key: ValueKey(todo.id),
                          todo: todo,
                          index: index,
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: const AddTodoBar(),
    );
  }
}
