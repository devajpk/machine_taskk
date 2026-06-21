import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_taskk/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:machine_taskk/features/todos/presentation/widget/colors.dart';

class Header extends StatelessWidget {
  const Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Todos',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              color: Palette.ink,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 4),
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              String label = ' ';
              if (state is TodoLoaded) {
                if (state.todos.isEmpty) {
                  label = 'Start your list';
                } else {
                  final remaining =
                      state.todos.where((t) => !t.isCompleted).length;
                  label = remaining == 0
                      ? 'All done'
                      : '$remaining ${remaining == 1 ? 'task' : 'tasks'} left';
                }
              }
              return Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Palette.inkFaded,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}