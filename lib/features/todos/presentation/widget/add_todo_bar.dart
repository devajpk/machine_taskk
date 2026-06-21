import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_taskk/features/todos/domain/entities/todo.dart';
import 'package:machine_taskk/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:machine_taskk/features/todos/presentation/widget/colors.dart';
import 'package:uuid/uuid.dart';

class AddTodoBar extends StatefulWidget {
  const AddTodoBar();

  @override
  State<AddTodoBar> createState() => _AddTodoBarState();
}

class _AddTodoBarState extends State<AddTodoBar> {
  final _controller = TextEditingController();
  final _uuid = Uuid();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<TodoBloc>().add(AddTodoEvent(Todo(id: _uuid.v4(), title: text)));
    _controller.clear();
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset + 16),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 6),
        decoration: BoxDecoration(
          color: Palette.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Palette.ink.withOpacity(0.10),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _submit(context),
                textInputAction: TextInputAction.done,
                style: const TextStyle(fontSize: 15.5, color: Palette.ink),
                decoration: const InputDecoration(
                  hintText: 'Add a task…',
                  hintStyle: TextStyle(color: Palette.inkFaded),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedScale(
              duration: const Duration(milliseconds: 160),
              scale: _hasText ? 1 : 0.85,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 160),
                opacity: _hasText ? 1 : 0.5,
                child: Material(
                  color: _hasText ? Palette.accent : const Color(0xFFE7E5E0),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _hasText ? () => _submit(context) : null,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.arrow_upward_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}