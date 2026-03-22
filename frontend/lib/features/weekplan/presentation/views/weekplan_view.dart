import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/domain/weekplan_state.dart';
import 'package:weekplanner/features/weekplan/presentation/weekplan_cubit.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/activity_list_item.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/week_selector.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

class WeekplanView extends StatelessWidget {
  final int citizenId;
  final bool isCitizen;
  final int? orgId;

  const WeekplanView({
    super.key,
    required this.citizenId,
    required this.isCitizen,
    this.orgId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ugeplan'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(
            '/weekplan/$citizenId/add?type=${isCitizen ? 'citizen' : 'grade'}&orgId=$orgId',
          );
        },
        backgroundColor: context.colorScheme.primary,
        child: Icon(Icons.add, color: context.colorScheme.onPrimary),
      ),
      body: BlocBuilder<WeekplanCubit, WeekplanState>(
        builder: (context, state) {
          final cubit = context.read<WeekplanCubit>();
          return Column(
            children: [
              WeekSelector(
                weekNumber: cubit.weekNumber,
                weekDates: state.weekDates,
                selectedDate: state.selectedDate,
                onPreviousWeek: cubit.goToPreviousWeek,
                onNextWeek: cubit.goToNextWeek,
                onSelectDate: cubit.selectDate,
              ),
              const Divider(height: 1),
              Expanded(
                child: _ActivityListArea(
                  state: state,
                  citizenId: citizenId,
                  isCitizen: isCitizen,
                  orgId: orgId,
                ),
              ),
            ],
          );
        },
      ),
    );
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
            style: TextStyle(color: context.colorScheme.outline, fontSize: 16),
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
    return RefreshIndicator(
      onRefresh: cubit.loadActivities,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          final media = activity.pictogramId != null
              ? pictogramMedia[activity.pictogramId!]
              : null;
          return ActivityListItem(
            activity: activity,
            imageUrl: media?.imageUrl,
            soundUrl: media?.soundUrl,
            onEdit: () {
              context.go(
                '/weekplan/$citizenId/edit/${activity.activityId}'
                '?type=${isCitizen ? 'citizen' : 'grade'}&orgId=$orgId',
                extra: activity,
              );
            },
            onDelete: () => cubit.deleteActivity(activity.activityId),
            onToggleStatus: () =>
                cubit.toggleActivityStatus(activity.activityId),
          );
        },
      ),
    );
  }
}
