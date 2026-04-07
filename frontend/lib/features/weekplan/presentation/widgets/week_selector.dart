import 'package:flutter/material.dart';
import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/shared/layout_constants.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

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

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isCurrentWeek = weekDates.any((d) => _isSameDay(d, now));
    final isTodaySelected = _isSameDay(selectedDate, now);
    return Column(
      children: [
        // Week navigation
        Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: GirafLayout.maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: onPreviousWeek,
              ),
              GestureDetector(
                onTap: isTodaySelected ? null : onGoToToday,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Uge $weekNumber',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (!isCurrentWeek || !isTodaySelected) ...[
                      const SizedBox(width: 8),
                      Text(
                        'I dag',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: context.colorScheme.primary,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: onNextWeek,
              ),
            ],
          ),
        ),
          ),
        ),
        // Day buttons — centered row of larger buttons
        SizedBox(
          height: 80,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final date in weekDates)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: _DayButton(
                      date: date,
                      isSelected: _isSameDay(date, selectedDate),
                      isToday: _isSameDay(date, now),
                      onTap: () => onSelectDate(date),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.day == b.day && a.month == b.month && a.year == b.year;
}

class _DayButton extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const _DayButton({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: GirafLayout.daySelectorSize,
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primary
              : context.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(GirafShape.radiusMedium),
          border: isToday && !isSelected
              ? Border.all(
                  color: context.colorScheme.primary,
                  width: 2,
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              GirafDateUtils.dayNameShort(date.weekday),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? context.colorScheme.onPrimary
                    : context.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? context.colorScheme.onPrimary
                    : context.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
