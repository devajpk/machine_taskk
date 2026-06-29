import 'package:flutter/material.dart';

class QuickAction {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback? onPressed;

  const QuickAction({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onPressed,
  });
}
