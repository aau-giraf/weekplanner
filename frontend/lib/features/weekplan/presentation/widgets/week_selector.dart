import 'package:flutter/material.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

/// Week navigation strip: week-number pill, today-jump pill, and one
/// selectable day chip per weekday, with previous/next-week arrows.
class WeekSelector extends StatelessWidget {
  final int weekNumber;
  final List<DateTime> weekDates;
  final DateTime selectedDate;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;
  final VoidCallback onGoToToday;
  final ValueChanged<DateTime> onSelectDate;

  const WeekSelector({
    super.key,
    required this.weekNumber,
    required this.weekDates,
    required this.selectedDate,
    required this.onPreviousWeek,
    required this.onNextWeek,
    required this.onGoToToday,
    required this.onSelectDate,
  });

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.day == b.day && a.month == b.month && a.year == b.year;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isTodaySelected = _isSameDay(selectedDate, now);
    return Column(
      children: [
        Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: GirafLayout.maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GirafSpacing.lg,
                vertical: GirafSpacing.sm,
              ),
              child: Row(
                children: [
                  _NavArrow(
                    icon: Icons.chevron_left,
                    onPressed: onPreviousWeek,
                    semanticLabel: 'Forrige uge',
                  ),
                  const Spacer(),
                  _WeekNumberPill(weekNumber: weekNumber),
                  const SizedBox(width: GirafSpacing.md),
                  _TodayPill(
                    onPressed: isTodaySelected ? null : onGoToToday,
                  ),
                  const Spacer(),
                  _NavArrow(
                    icon: Icons.chevron_right,
                    onPressed: onNextWeek,
                    semanticLabel: 'Næste uge',
                  ),
                ],
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: GirafSpacing.lg,
            vertical: GirafSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final date in weekDates)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GirafSpacing.xs,
                  ),
                  child: _DayChip(
                    date: date,
                    isSelected: _isSameDay(date, selectedDate),
                    isToday: _isSameDay(date, now),
                    onTap: () => onSelectDate(date),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String semanticLabel;

  const _NavArrow({
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: GirafColors.brownDark),
      iconSize: 28,
      onPressed: onPressed,
      tooltip: semanticLabel,
    );
  }
}

class _WeekNumberPill extends StatelessWidget {
  final int weekNumber;
  const _WeekNumberPill({required this.weekNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GirafSpacing.lg,
        vertical: GirafSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: GirafColors.brownDark,
        borderRadius: GirafRadii.pillRadius,
      ),
      child: Text(
        'Uge $weekNumber',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _TodayPill extends StatelessWidget {
  final VoidCallback? onPressed;
  const _TodayPill({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(
          horizontal: GirafSpacing.lg,
          vertical: GirafSpacing.xs,
        ),
      ),
      child: const Text('I dag'),
    );
  }
}

class _DayChip extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const _DayChip({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final background = isSelected
        ? GirafColors.primaryOrange
        : GirafColors.surface;
    final foreground = isSelected
        ? Colors.white
        : GirafColors.brownDark;
    final border = (isToday && !isSelected)
        ? Border.all(color: GirafColors.brownDark, width: 2)
        : Border.all(color: GirafColors.outline);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: GirafRadii.pillRadius,
        child: AnimatedContainer(
          duration: GirafMotion.dayChip,
          curve: GirafMotion.standard,
          padding: const EdgeInsets.symmetric(
            horizontal: GirafSpacing.lg,
            vertical: GirafSpacing.md,
          ),
          constraints: const BoxConstraints(minWidth: 72, minHeight: 56),
          decoration: BoxDecoration(
            color: background,
            borderRadius: GirafRadii.pillRadius,
            border: border,
            boxShadow: isSelected ? null : GirafElevation.card,
          ),
          alignment: Alignment.center,
          child: Text(
            '${GirafDateUtils.dayNameShort(date.weekday)} ${date.day}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}
