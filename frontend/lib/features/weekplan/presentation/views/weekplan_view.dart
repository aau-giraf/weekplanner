import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/domain/weekplan_state.dart';
import 'package:weekplanner/features/weekplan/presentation/weekplan_cubit.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/activity_list_item.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/choice_selector_dialog.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/week_overview.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/week_selector.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

/// Weekplan screen with toggle between day view and week overview.
///
/// Uses [StatefulWidget] for ephemeral view-mode toggle and selection state.
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
  bool _isSelecting = false;
  final Set<int> _selectedIds = {};

  void _toggleViewMode() {
    setState(() {
      _isWeekView = !_isWeekView;
      _exitSelectionMode();
    });
    if (_isWeekView) {
      context.read<WeekplanCubit>().loadWeekActivities();
    }
  }

  void _switchToDayView(DateTime date) {
    setState(() {
      _isWeekView = false;
      _exitSelectionMode();
    });
    context.read<WeekplanCubit>().selectDate(date);
  }

  void _enterSelectionMode(int activityId) {
    setState(() {
      _isSelecting = true;
      _selectedIds.add(activityId);
    });
  }

  void _toggleSelection(int activityId) {
    setState(() {
      if (_selectedIds.contains(activityId)) {
        _selectedIds.remove(activityId);
        if (_selectedIds.isEmpty) _isSelecting = false;
      } else {
        _selectedIds.add(activityId);
      }
    });
  }

  void _selectAll(List<Activity> activities) {
    setState(() {
      _selectedIds.addAll(activities.map((a) => a.activityId));
    });
  }

  void _exitSelectionMode() {
    _isSelecting = false;
    _selectedIds.clear();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSelecting,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(_exitSelectionMode);
      },
      child: Scaffold(
      appBar: _isSelecting
          ? _SelectionAppBar(
              selectedCount: _selectedIds.length,
              onClose: () => setState(_exitSelectionMode),
              onSelectAll: () {
                final state = context.read<WeekplanCubit>().state;
                if (state is WeekplanLoaded) _selectAll(state.activities);
              },
            )
          : AppBar(
              title: Text(
                widget.subjectName != null
                    ? 'Ugeplan — ${widget.subjectName}'
                    : 'Ugeplan',
              ),
              actions: [
                IconButton(
                  icon:
                      Icon(_isWeekView ? Icons.view_day : Icons.view_week),
                  tooltip: _isWeekView ? 'Dagvisning' : 'Ugeoversigt',
                  onPressed: _toggleViewMode,
                ),
                if (!_isWeekView)
                  BlocBuilder<WeekplanCubit, WeekplanState>(
                    builder: (context, state) {
                      final hasActivities = state is WeekplanLoaded &&
                          state.activities.isNotEmpty;
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
      floatingActionButton: _isWeekView || _isSelecting
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
      bottomNavigationBar: _isSelecting
          ? _SelectionActionBar(
              selectedIds: _selectedIds,
              citizenId: widget.citizenId,
              isCitizen: widget.isCitizen,
              onDone: () => setState(_exitSelectionMode),
            )
          : null,
      body: BlocBuilder<WeekplanCubit, WeekplanState>(
        builder: (context, state) {
          final cubit = context.read<WeekplanCubit>();
          return Column(
            children: [
              if (!_isWeekView && !_isSelecting) ...[
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
                        isSelecting: _isSelecting,
                        selectedIds: _selectedIds,
                        onLongPress: _enterSelectionMode,
                        onToggleSelection: _toggleSelection,
                      ),
              ),
            ],
          );
        },
      ),
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

// ── Selection mode app bar ────────────────────────────────

class _SelectionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int selectedCount;
  final VoidCallback onClose;
  final VoidCallback onSelectAll;

  const _SelectionAppBar({
    required this.selectedCount,
    required this.onClose,
    required this.onSelectAll,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: onClose,
      ),
      title: Text('$selectedCount valgt'),
      actions: [
        TextButton(
          onPressed: onSelectAll,
          child: const Text('Vælg alle'),
        ),
      ],
    );
  }
}

// ── Selection action bar ──────────────────────────────────

class _SelectionActionBar extends StatelessWidget {
  final Set<int> selectedIds;
  final int citizenId;
  final bool isCitizen;
  final VoidCallback onDone;

  const _SelectionActionBar({
    required this.selectedIds,
    required this.citizenId,
    required this.isCitizen,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            icon: Icons.delete_outline,
            label: 'Slet',
            color: Theme.of(context).colorScheme.error,
            onTap: () => _bulkDelete(context),
          ),
          _ActionButton(
            icon: Icons.copy,
            label: 'Kopiér',
            onTap: () => _bulkCopy(context),
          ),
          _ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Færdig',
            onTap: () => _bulkComplete(context),
          ),
        ],
      ),
    );
  }

  Future<void> _bulkDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Slet aktiviteter'),
        content: Text(
          'Er du sikker på du vil slette ${selectedIds.length} aktiviteter?',
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
    if (confirmed != true || !context.mounted) return;

    final cubit = context.read<WeekplanCubit>();
    final removedActivities = <Activity>[];
    for (final id in selectedIds) {
      final removed = cubit.hideActivity(id);
      if (removed != null) removedActivities.add(removed);
    }
    onDone();
    if (!context.mounted) return;

    var undone = false;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removedActivities.length} aktiviteter slettet'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Fortryd',
          onPressed: () {
            undone = true;
            for (final a in removedActivities) {
              cubit.restoreActivity(a);
            }
          },
        ),
      ),
    ).closed.then((_) {
      if (!undone && context.mounted) {
        for (final a in removedActivities) {
          cubit.confirmDelete(a.activityId, a);
        }
      }
    });
  }

  Future<void> _bulkCopy(BuildContext context) async {
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

    final current = cubit.state;
    if (current is! WeekplanLoaded) return;

    final count = selectedIds.length;
    final ids = selectedIds.toList();
    final result = await cubit.copySelectedToDate(
      activityIds: ids,
      targetDate: targetDate,
    );
    onDone();
    if (!context.mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    } else {
      final formatted = GirafDateUtils.formatDateDDMM(targetDate);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$count aktiviteter kopieret til $formatted'),
        ),
      );
    }
  }

  void _bulkComplete(BuildContext context) {
    final cubit = context.read<WeekplanCubit>();
    final current = cubit.state;
    if (current is! WeekplanLoaded) return;

    // Only toggle activities that are not yet completed
    final idsToComplete = selectedIds.where((id) {
      final activity = current.activities
          .where((a) => a.activityId == id)
          .firstOrNull;
      return activity != null && !activity.isCompleted;
    }).toList();

    for (final id in idsToComplete) {
      cubit.toggleActivityStatus(id);
    }
    onDone();
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: effectiveColor),
      label: Text(
        label,
        style: TextStyle(color: effectiveColor),
      ),
    );
  }
}

// ── Week overview area ────────────────────────────────────

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

// ── Day view area ─────────────────────────────────────────

class _ActivityListArea extends StatelessWidget {
  final WeekplanState state;
  final int citizenId;
  final bool isCitizen;
  final int? orgId;
  final bool isSelecting;
  final Set<int> selectedIds;
  final ValueChanged<int> onLongPress;
  final ValueChanged<int> onToggleSelection;

  const _ActivityListArea({
    required this.state,
    required this.citizenId,
    required this.isCitizen,
    this.orgId,
    required this.isSelecting,
    required this.selectedIds,
    required this.onLongPress,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      WeekplanLoading() => const Center(child: CircularProgressIndicator()),
      WeekplanError(:final message) => _ErrorWithRetry(message: message),
      WeekplanLoaded(:final activities) when activities.isEmpty =>
        _EmptyDay(selectedDate: state.selectedDate),
      WeekplanLoaded(:final activities, :final pictogramMedia) =>
        _ActivityList(
          activities: activities,
          pictogramMedia: pictogramMedia,
          citizenId: citizenId,
          isCitizen: isCitizen,
          orgId: orgId,
          isSelecting: isSelecting,
          selectedIds: selectedIds,
          onLongPress: onLongPress,
          onToggleSelection: onToggleSelection,
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
          FilledButton(
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
  final bool isSelecting;
  final Set<int> selectedIds;
  final ValueChanged<int> onLongPress;
  final ValueChanged<int> onToggleSelection;

  const _ActivityList({
    required this.activities,
    required this.pictogramMedia,
    required this.citizenId,
    required this.isCitizen,
    this.orgId,
    required this.isSelecting,
    required this.selectedIds,
    required this.onLongPress,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WeekplanCubit>();

    if (isSelecting) {
      return ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          final media = activity.pictogramId != null
              ? pictogramMedia[activity.pictogramId!]
              : null;
          final isSelected = selectedIds.contains(activity.activityId);
          return _SelectableActivityItem(
            activity: activity,
            imageUrl: media?.imageUrl,
            isSelected: isSelected,
            onTap: () => onToggleSelection(activity.activityId),
          );
        },
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      onReorder: cubit.reorderActivities,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(GirafShape.radiusMedium),
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
          onLongPress: () => onLongPress(activity.activityId),
          onChoiceTap: activity.options.isNotEmpty &&
                  activity.selectedOptionIndex == null
              ? () => _showChoiceSelector(context, activity, cubit)
              : null,
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
    if (confirmed != true || !context.mounted) return;

    final removed = cubit.hideActivity(activity.activityId);
    if (removed == null || !context.mounted) return;

    var undone = false;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Aktivitet "${activity.title ?? 'denne aktivitet'}" slettet',
        ),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Fortryd',
          onPressed: () {
            undone = true;
            cubit.restoreActivity(removed);
          },
        ),
      ),
    ).closed.then((_) {
      if (!undone && context.mounted) {
        cubit.confirmDelete(activity.activityId, removed);
      }
    });
  }

  Future<void> _showChoiceSelector(
    BuildContext context,
    Activity activity,
    WeekplanCubit cubit,
  ) async {
    final current = cubit.state;
    if (current is! WeekplanLoaded) return;

    final selectedIndex = await showDialog<int>(
      context: context,
      builder: (context) => ChoiceSelectorDialog(
        activity: activity,
        pictogramMedia: current.pictogramMedia,
      ),
    );
    if (selectedIndex == null || !context.mounted) return;

    cubit.selectOption(activity.activityId, selectedIndex);
  }
}

// ── Selectable activity item (selection mode) ─────────────

class _SelectableActivityItem extends StatelessWidget {
  final Activity activity;
  final String? imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableActivityItem({
    required this.activity,
    this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        color: isSelected
            ? context.colorScheme.primaryContainer
            : null,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(GirafShape.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => onTap(),
                ),
                const SizedBox(width: 8),
                // Pictogram thumbnail
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(GirafShape.radiusSmall),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.image,
                            size: 24,
                            color: context.colorScheme.onPrimaryContainer,
                          ),
                        )
                      : Icon(
                          Icons.event,
                          size: 24,
                          color: context.colorScheme.onPrimaryContainer,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    activity.title ?? 'Unavngivet aktivitet',
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
