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

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: weekDates.length,
      itemBuilder: (context, index) {
        final date = weekDates[index];
        final dateKey = GirafDateUtils.formatQueryDate(date);
        final activities = weekActivities[dateKey] ?? const [];
        return _DayColumn(
          date: date,
          activities: activities,
          pictogramMedia: pictogramMedia,
          onTap: () => onSelectDay(date),
        );
      },
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
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DayHeader(date: date, isToday: isToday),
              if (activities.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Ingen aktiviteter',
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
    return Row(
      children: [
        Text(
          '${GirafDateUtils.dayName(date.weekday)} ${GirafDateUtils.formatDateDDMM(date)}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isToday ? context.colorScheme.primary : null,
              ),
        ),
        if (isToday) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'I dag',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
            ),
          ),
        ],
        const Spacer(),
        Icon(
          Icons.chevron_right,
          color: context.colorScheme.outline,
          size: 20,
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
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          // Small pictogram thumbnail
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: activity.isCompleted
                  ? context.girafColors.completedBackground
                  : context.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            clipBehavior: Clip.antiAlias,
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.image,
                      size: 16,
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                  )
                : Icon(
                    Icons.event,
                    size: 16,
                    color: context.colorScheme.onPrimaryContainer,
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              activity.title ?? 'Unavngivet aktivitet',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    decoration: activity.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: activity.isCompleted
                        ? context.colorScheme.outline
                        : null,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (activity.isCompleted)
            Icon(
              Icons.check_circle,
              size: 16,
              color: context.girafColors.completedIndicator,
            ),
        ],
      ),
    );
  }
}
