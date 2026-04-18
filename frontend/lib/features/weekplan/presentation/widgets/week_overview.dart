import 'package:flutter/material.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/domain/weekplan_state.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

/// Condensed 7-day overview. Each day column shows its header and a
/// vertical list of small activity thumbnails. Tapping a column
/// switches the weekplan view to the day view for that date.
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
          padding: const EdgeInsets.all(GirafSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final date in weekDates)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: GirafSpacing.xs,
                    ),
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

    return DecoratedBox(
      decoration: BoxDecoration(
        color: GirafColors.surface,
        borderRadius: GirafRadii.cardRadius,
        boxShadow: GirafElevation.card,
        border: isToday
            ? Border.all(color: GirafColors.brownDark, width: 2)
            : null,
      ),
      child: ClipRRect(
        borderRadius: GirafRadii.cardRadius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(GirafSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _DayHeader(date: date, isToday: isToday),
                  const SizedBox(height: GirafSpacing.xs),
                  if (activities.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: GirafSpacing.sm),
                      child: Text(
                        'Ingen',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
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
    final accent = isToday ? GirafColors.primaryOrange : GirafColors.brownDark;
    return Column(
      children: [
        Text(
          GirafDateUtils.dayNameShort(date.weekday),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: accent,
              ),
        ),
        Text(
          '${date.day}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: accent,
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
      padding: const EdgeInsets.only(top: GirafSpacing.xs),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: activity.isCompleted
                  ? context.girafColors.completedBackground
                  : context.girafColors.pendingBackground,
              borderRadius: GirafRadii.inputRadius,
            ),
            clipBehavior: Clip.antiAlias,
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.image,
                      size: 20,
                      color: GirafColors.brownMuted,
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.event,
                      size: 20,
                      color: GirafColors.brownMuted,
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
