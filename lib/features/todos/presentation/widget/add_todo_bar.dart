import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_taskk/features/todos/domain/entities/todo.dart';
import 'package:machine_taskk/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:machine_taskk/features/todos/presentation/widget/colors.dart';
import 'package:uuid/uuid.dart';

class AddTodoBar extends StatefulWidget {
  const AddTodoBar({super.key});

  @override
  State<AddTodoBar> createState() => _AddTodoBarState();
}

class _AddTodoBarState extends State<AddTodoBar> {
  final _controller = TextEditingController();
  final _uuid = Uuid();
  late DateTime _selectedDate;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
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
    context.read<TodoBloc>().add(
          AddTodoEvent(
            Todo(
              id: _uuid.v4(),
              title: text,
              createdAt: _selectedDateTime(),
            ),
          ),
        );
    _controller.clear();
    HapticFeedback.selectionClick();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035, 12, 31),
    );

    if (picked == null || !mounted) return;

    setState(() {
      _selectedDate = DateTime(picked.year, picked.month, picked.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset + 12),
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 6),
          decoration: BoxDecoration(
            color: Palette.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Palette.ink.withValues(alpha: 0.10),
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
                    hintText: 'Add a task...',
                    hintStyle: TextStyle(color: Palette.inkFaded),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: 'Todo date',
                child: TextButton.icon(
                  onPressed: () => _pickDate(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Palette.ink,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.calendar_today_rounded, size: 16),
                  label: Text(
                    _dateLabel(_selectedDate),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
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
      ),
    );
  }

  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (date == today) return 'Today';
    return '${date.day}/${date.month}';
  }

  DateTime _selectedDateTime() {
    final now = DateTime.now();
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
      now.microsecond,
    );
  }
}
