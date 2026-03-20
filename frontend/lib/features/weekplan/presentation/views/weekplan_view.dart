import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/presentation/view_models/weekplan_view_model.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/activity_list_item.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/week_selector.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

class WeekplanView extends StatefulWidget {
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
  State<WeekplanView> createState() => _WeekplanViewState();
}

class _WeekplanViewState extends State<WeekplanView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeekplanViewModel>().loadActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ugeplan'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/weekplan/${widget.citizenId}/add?type=${widget.isCitizen ? 'citizen' : 'grade'}&orgId=${widget.orgId}');
        },
        backgroundColor: GirafColors.orange,
        child: const Icon(Icons.add, color: GirafColors.white),
      ),
      body: Consumer<WeekplanViewModel>(
        builder: (context, vm, _) {
          return Column(
            children: [
              WeekSelector(
                weekNumber: vm.weekNumber,
                weekDates: vm.weekDates,
                selectedDate: vm.selectedDate,
                onPreviousWeek: vm.goToPreviousWeek,
                onNextWeek: vm.goToNextWeek,
                onSelectDate: vm.selectDate,
              ),
              const Divider(height: 1),
              // Activity list
              Expanded(
                child: _buildActivityList(context, vm),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActivityList(BuildContext context, WeekplanViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(vm.error!, style: const TextStyle(color: GirafColors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: vm.loadActivities,
              child: const Text('Prøv igen'),
            ),
          ],
        ),
      );
    }

    if (vm.activities.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy, size: 64, color: GirafColors.gray),
            const SizedBox(height: 16),
            Text(
              'Ingen aktiviteter for ${GirafDateUtils.dayName(vm.selectedDate.weekday)}',
              style: TextStyle(color: GirafColors.gray, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: vm.loadActivities,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: vm.activities.length,
        itemBuilder: (context, index) {
          final activity = vm.activities[index];
          return ActivityListItem(
            activity: activity,
            soundUrl: activity.pictogramId != null
                ? vm.getSoundUrl(activity.pictogramId!)
                : null,
            onEdit: () {
              context.go(
                '/weekplan/${widget.citizenId}/edit/${activity.activityId}'
                '?type=${widget.isCitizen ? 'citizen' : 'grade'}&orgId=${widget.orgId}',
              );
            },
            onDelete: () => vm.deleteActivity(activity.activityId),
            onToggleStatus: () => vm.toggleActivityStatus(activity.activityId),
          );
        },
      ),
    );
  }
}
