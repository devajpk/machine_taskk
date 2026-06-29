import 'package:flutter/material.dart';
import 'package:machine_taskk/features/dashboard/presentation/widget/round_button.dart';
import 'package:machine_taskk/features/profiles/presentation/widgets/profile_branding.dart';

const _themeTransition = Duration(milliseconds: 280);
const _themeCurve = Curves.easeOutCubic;

class CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final ProfileBranding branding;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const CalendarHeader({
    super.key,
    required this.focusedDay,
    required this.branding,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final monthName = _monthNames[focusedDay.month - 1];

    return Row(
      children: [
        AnimatedContainer(
          duration: _themeTransition,
          curve: _themeCurve,
          width: 42,
          height: 42,
          // Badge icon container: explicit borderRadius only, same rule as
          // the appbar/hero badges above — never paired with `shape:`.
          decoration: BoxDecoration(
            borderRadius: branding.cellBorderRadius,
            gradient: branding.monochrome
                ? null
                : LinearGradient(colors: branding.accentGradient),
            color: branding.monochrome ? branding.headerColor : null,
          ),
          child: Icon(
            Icons.calendar_month,
            color: _bestForegroundFor(branding.headerColor),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedDefaultTextStyle(
                duration: _themeTransition,
                curve: _themeCurve,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: branding.primaryTextColor,
                      fontWeight: FontWeight.w800,
                    ),
                child: const Text('Workspace Calendar'),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: _themeTransition,
                curve: _themeCurve,
                style: TextStyle(color: branding.secondaryTextColor),
                child: Text('$monthName ${focusedDay.year}'),
              ),
            ],
          ),
        ),
        RoundIconButton(
          icon: Icons.chevron_left,
          tooltip: 'Previous month',
          onPressed: onPreviousMonth,
          branding: branding,
        ),
        const SizedBox(width: 6),
        RoundIconButton(
          icon: Icons.chevron_right,
          tooltip: 'Next month',
          onPressed: onNextMonth,
          branding: branding,
        ),
      ],
    );
  }
}

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
Color _bestForegroundFor(Color color) {
  return color.computeLuminance() > 0.45 ? Colors.black87 : Colors.white;
}
