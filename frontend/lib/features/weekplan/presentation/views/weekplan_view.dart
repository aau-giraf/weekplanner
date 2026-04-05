import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/domain/weekplan_state.dart';
import 'package:weekplanner/features/weekplan/presentation/weekplan_cubit.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/activity_list_item.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/week_overview.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/week_selector.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

/// Weekplan screen with toggle between day view and week overview.
///
/// Uses [StatefulWidget] for the ephemeral view-mode toggle state.
class WeekplanView extends StatefulWidget {
  final int citizenId;
  final bool isCitizen;
  final int? orgId;
  final String? subjectName;

  const WeekplanView({
    super.key,
    required this.citizenId,
    required this.isCitizen,
    this.orgId,
    this.subjectName,
  });

  @override
  State<WeekplanView> createState() => _WeekplanViewState();
}

class _WeekplanViewState extends State<WeekplanView> {
  bool _isWeekView = false;

  void _toggleViewMode() {
    setState(() {
      _isWeekView = !_isWeekView;
    });
    if (_isWeekView) {
      context.read<WeekplanCubit>().loadWeekActivities();
    }
  }

  void _switchToDayView(DateTime date) {
    setState(() {
      _isWeekView = false;
    });
    context.read<WeekplanCubit>().selectDate(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subjectName != null
              ? 'Ugeplan — ${widget.subjectName}'
              : 'Ugeplan',
        ),
        actions: [
          IconButton(
            icon: Icon(_isWeekView ? Icons.view_day : Icons.view_week),
            tooltip: _isWeekView ? 'Dagvisning' : 'Ugeoversigt',
            onPressed: _toggleViewMode,
          ),
          if (!_isWeekView)
            BlocBuilder<WeekplanCubit, WeekplanState>(
              builder: (context, state) {
                final hasActivities =
                    state is WeekplanLoaded && state.activities.isNotEmpty;
                return IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Kopiér dag',
                  onPressed: hasActivities
                      ? () => _showCopyDayPicker(context)
                      : null,
                );
              },
            ),
        ],
      ),
      floatingActionButton: _isWeekView
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final selectedDate =
                    context.read<WeekplanCubit>().state.selectedDate;
                final dateStr =
                    selectedDate.toIso8601String().split('T').first;
                final saved = await context.push<bool>(
                  '/weekplan/${widget.citizenId}/add?type=${widget.isCitizen ? 'citizen' : 'grade'}&orgId=${widget.orgId}&date=$dateStr',
                );
                if (saved == true && context.mounted) {
                  context.read<WeekplanCubit>().loadActivities();
                }
              },
              backgroundColor: context.colorScheme.primary,
              child: Icon(Icons.add, color: context.colorScheme.onPrimary),
            ),
      body: BlocBuilder<WeekplanCubit, WeekplanState>(
        builder: (context, state) {
          final cubit = context.read<WeekplanCubit>();
          return Column(
            children: [
              if (!_isWeekView) ...[
                WeekSelector(
                  weekNumber: cubit.weekNumber,
                  weekDates: state.weekDates,
                  selectedDate: state.selectedDate,
                  onPreviousWeek: cubit.goToPreviousWeek,
                  onNextWeek: cubit.goToNextWeek,
                  onGoToToday: cubit.goToToday,
                  onSelectDate: cubit.selectDate,
                ),
                const Divider(height: 1),
              ],
              Expanded(
                child: _isWeekView
                    ? _WeekOverviewArea(
                        state: state,
                        onSelectDay: _switchToDayView,
                      )
                    : _ActivityListArea(
                        state: state,
                        citizenId: widget.citizenId,
                        isCitizen: widget.isCitizen,
                        orgId: widget.orgId,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> _showCopyDayPicker(BuildContext context) async {
  final cubit = context.read<WeekplanCubit>();
  final sourceDate = cubit.state.selectedDate;

  final targetDate = await showDatePicker(
    context: context,
    initialDate: sourceDate.add(const Duration(days: 1)),
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
    helpText: 'Kopiér aktiviteter til',
  );
  if (targetDate == null || !context.mounted) return;

  final isSameDay = targetDate.year == sourceDate.year &&
      targetDate.month == sourceDate.month &&
      targetDate.day == sourceDate.day;
  if (isSameDay) return;

  final error = await cubit.copyDayToDate(targetDate);
  if (!context.mounted) return;

  if (error != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  } else {
    final formatted = GirafDateUtils.formatDateDDMM(targetDate);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Aktiviteter kopieret til $formatted')),
    );
  }
}

class _WeekOverviewArea extends StatelessWidget {
  final WeekplanState state;
  final ValueChanged<DateTime> onSelectDay;

  const _WeekOverviewArea({
    required this.state,
    required this.onSelectDay,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      WeekplanLoading() => const Center(child: CircularProgressIndicator()),
      WeekplanError(:final message) => _ErrorWithRetry(message: message),
      WeekplanLoaded(
        :final weekDates,
        :final weekActivities,
        :final pictogramMedia,
      ) =>
        WeekOverview(
          weekDates: weekDates,
          weekActivities: weekActivities,
          pictogramMedia: pictogramMedia,
          onSelectDay: onSelectDay,
        ),
    };
  }
}

class _ActivityListArea extends StatelessWidget {
  final WeekplanState state;
  final int citizenId;
  final bool isCitizen;
  final int? orgId;

  const _ActivityListArea({
    required this.state,
    required this.citizenId,
    required this.isCitizen,
    this.orgId,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      WeekplanLoading() => const Center(child: CircularProgressIndicator()),
      WeekplanError(:final message) => _ErrorWithRetry(message: message),
      WeekplanLoaded(:final activities) when activities.isEmpty =>
        _EmptyDay(selectedDate: state.selectedDate),
      WeekplanLoaded(:final activities, :final pictogramMedia) => _ActivityList(
          activities: activities,
          pictogramMedia: pictogramMedia,
          citizenId: citizenId,
          isCitizen: isCitizen,
          orgId: orgId,
        ),
    };
  }
}

class _ErrorWithRetry extends StatelessWidget {
  final String message;

  const _ErrorWithRetry({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: TextStyle(color: context.colorScheme.error),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<WeekplanCubit>().loadActivities(),
            child: const Text('Prøv igen'),
          ),
        ],
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  final DateTime selectedDate;

  const _EmptyDay({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy, size: 64, color: context.colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            'Ingen aktiviteter for ${GirafDateUtils.dayName(selectedDate.weekday)}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}

class _ActivityList extends StatelessWidget {
  final List<Activity> activities;
  final Map<int, PictogramMedia> pictogramMedia;
  final int citizenId;
  final bool isCitizen;
  final int? orgId;

  const _ActivityList({
    required this.activities,
    required this.pictogramMedia,
    required this.citizenId,
    required this.isCitizen,
    this.orgId,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WeekplanCubit>();
    return ReorderableListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      onReorder: cubit.reorderActivities,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: child,
          ),
          child: child,
        );
      },
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        final media = activity.pictogramId != null
            ? pictogramMedia[activity.pictogramId!]
            : null;
        return ActivityListItem(
          key: ValueKey(activity.activityId),
          activity: activity,
          imageUrl: media?.imageUrl,
          soundUrl: media?.soundUrl,
          onEdit: () async {
            final dateStr =
                activity.date.toIso8601String().split('T').first;
            final saved = await context.push<bool>(
              '/weekplan/$citizenId/edit/${activity.activityId}'
              '?type=${isCitizen ? 'citizen' : 'grade'}&orgId=$orgId&date=$dateStr',
              extra: activity,
            );
            if (saved == true && context.mounted) {
              context.read<WeekplanCubit>().loadActivities();
            }
          },
          onDelete: () => _confirmDelete(context, activity, cubit),
          onToggleStatus: () =>
              cubit.toggleActivityStatus(activity.activityId),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Activity activity,
    WeekplanCubit cubit,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Slet aktivitet'),
        content: Text(
          'Er du sikker på du vil slette "${activity.title ?? 'denne aktivitet'}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuller'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Slet',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      cubit.deleteActivity(activity.activityId);
    }
  }
}
