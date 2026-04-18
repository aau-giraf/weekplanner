import 'package:flutter/material.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/domain/weekplan_state.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

/// Displays a condensed overview of all 7 days in the week.
///
/// Each day shows its name, date, and a list of activity summaries
/// (pictogram placeholder + title). Tapping a day header switches
/// to the day view for that day.
class WeekOverview extends StatelessWidget {
  final List<DateTime> weekDates;
  final Map<String, List<Activity>> weekActivities;
  final Map<int, PictogramMedia> pictogramMedia;
  final ValueChanged<DateTime> onSelectDay;

  const WeekOverview({
    super.key,
    required this.weekDates,
    required this.weekActivities,
    required this.pictogramMedia,
    required this.onSelectDay,
  });

  @override
  Widget build(BuildContext context) {
    if (weekActivities.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: GirafLayout.maxContentWidth),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final date in weekDates)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _DayColumn(
                      date: date,
                      activities: weekActivities[
                              GirafDateUtils.formatQueryDate(date)] ??
                          const [],
                      pictogramMedia: pictogramMedia,
                      onTap: () => onSelectDay(date),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayColumn extends StatelessWidget {
  final DateTime date;
  final List<Activity> activities;
  final Map<int, PictogramMedia> pictogramMedia;
  final VoidCallback onTap;

  const _DayColumn({
    required this.date,
    required this.activities,
    required this.pictogramMedia,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday = date.day == now.day &&
        date.month == now.month &&
        date.year == now.year;

    return Card(
      shape: isToday
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(GirafRadii.card),
              side: BorderSide(color: context.colorScheme.primary, width: 2),
            )
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(GirafRadii.card),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _DayHeader(date: date, isToday: isToday),
              const SizedBox(height: 4),
              if (activities.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Ingen',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.outline,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                )
              else
                ...activities.map(
                  (a) => _ActivityRow(
                    activity: a,
                    imageUrl: a.pictogramId != null
                        ? pictogramMedia[a.pictogramId!]?.imageUrl
                        : null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  final DateTime date;
  final bool isToday;

  const _DayHeader({required this.date, required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          GirafDateUtils.dayNameShort(date.weekday),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isToday ? context.colorScheme.primary : context.colorScheme.outline,
              ),
        ),
        Text(
          '${date.day}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isToday ? context.colorScheme.primary : null,
              ),
        ),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final Activity activity;
  final String? imageUrl;

  const _ActivityRow({
    required this.activity,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: activity.isCompleted
                  ? context.girafColors.completedBackground
                  : context.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(GirafRadii.input),
            ),
            clipBehavior: Clip.antiAlias,
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.image,
                      size: 20,
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                  )
                : Center(
                    child: Icon(
                      Icons.event,
                      size: 20,
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                  ),
          ),
          if (activity.isCompleted)
            Positioned(
              top: 2,
              right: 2,
              child: Icon(
                Icons.check_circle,
                size: 14,
                color: context.girafColors.completedIndicator,
              ),
            ),
        ],
      ),
    );
  }
}
