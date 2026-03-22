import 'package:flutter/material.dart';
import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

class WeekSelector extends StatelessWidget {
  final int weekNumber;
  final List<DateTime> weekDates;
  final DateTime selectedDate;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;
  final ValueChanged<DateTime> onSelectDate;

  const WeekSelector({
    super.key,
    required this.weekNumber,
    required this.weekDates,
    required this.selectedDate,
    required this.onPreviousWeek,
    required this.onNextWeek,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Week navigation
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: onPreviousWeek,
              ),
              Text(
                'Uge $weekNumber',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: onNextWeek,
              ),
            ],
          ),
        ),
        // Day buttons
        SizedBox(
          height: 64,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: weekDates.length,
            itemBuilder: (context, index) {
              final date = weekDates[index];
              final isSelected = date.day == selectedDate.day &&
                  date.month == selectedDate.month &&
                  date.year == selectedDate.year;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _DayButton(
                  date: date,
                  isSelected: isSelected,
                  onTap: () => onSelectDate(date),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DayButton extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayButton({
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primary
              : context.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              GirafDateUtils.dayNameShort(date.weekday),
              style: TextStyle(
                fontSize: 11,
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
                fontSize: 16,
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
