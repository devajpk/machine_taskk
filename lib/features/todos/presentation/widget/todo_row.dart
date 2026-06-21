
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_taskk/features/todos/domain/entities/todo.dart';
import 'package:machine_taskk/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:machine_taskk/features/todos/presentation/widget/animated_checker.dart';
import 'package:machine_taskk/features/todos/presentation/widget/colors.dart';

class TodoRow extends StatefulWidget {
  const TodoRow({super.key, required this.todo, required this.index});
  final Todo todo;
  final int index;

  @override
  State<TodoRow> createState() => _TodoRowState();
}
class _TodoRowState extends State<TodoRow>
   with SingleTickerProviderStateMixin {
 late final AnimationController _entrance;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    Future.delayed(Duration(milliseconds: 28 * (widget.index % 8)), () {
      if (mounted) _entrance.forward();
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;
    return FadeTransition(
      opacity: _entrance,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic)),
        child: Dismissible(
          key: ValueKey('dismiss-${todo.id}'),
          direction: DismissDirection.endToStart,
          background: const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete_outline_rounded,
                  color: Palette.danger, size: 22),
            ),
          ),
          confirmDismiss: (_) async {
            context.read<TodoBloc>().add(DeleteTodoEvent(todo.id));
            return true;
          },
          child: InkWell(
            onTap: () => context.read<TodoBloc>().add(ToggleTodoEvent(todo)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  AnimatedCheck(checked: todo.isCompleted),
                  const SizedBox(width: 14),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 220),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: todo.isCompleted
                            ? Palette.inkFaded
                            : Palette.ink,
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: Palette.inkFaded,
                        decorationThickness: 1.6,
                      ),
                      child: Text(todo.title),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    color: Palette.inkFaded,
                    splashRadius: 18,
                    visualDensity: VisualDensity.compact,
                    onPressed: () => context
                        .read<TodoBloc>()
                        .add(DeleteTodoEvent(todo.id)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



