import 'package:flutter/material.dart';
import 'package:machine_taskk/features/todos/presentation/widget/colors.dart';

class EmptyState extends StatelessWidget {
  const EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.spa_outlined, size: 38, color: Palette.inkFaded),
            const SizedBox(height: 14),
            const Text(
              'Nothing on your list',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Palette.ink,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add your first task below to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Palette.inkFaded,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}