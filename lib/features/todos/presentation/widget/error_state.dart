import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_taskk/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:machine_taskk/features/todos/presentation/widget/colors.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 34, color: Palette.danger),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Palette.inkFaded),
            ),
            const SizedBox(height: 14),
            TextButton(
              onPressed: () =>
                  context.read<TodoBloc>().add(LoadTodosEvent()),
              style: TextButton.styleFrom(foregroundColor: Palette.accent),
              child: const Text(
                'Try again',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}