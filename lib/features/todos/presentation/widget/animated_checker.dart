import 'package:flutter/material.dart';
import 'package:machine_taskk/features/todos/presentation/widget/colors.dart';

class AnimatedCheck extends StatelessWidget {
  const AnimatedCheck({required this.checked});
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: checked ? Palette.success : Colors.transparent,
        border: Border.all(
          color: checked ? Palette.success : Palette.checkboxIdle,
          width: 2,
        ),
      ),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutBack,
        scale: checked ? 1 : 0,
        child: const Icon(Icons.check_rounded, size: 15, color: Colors.white),
      ),
    );
  }
}