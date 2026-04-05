import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/domain/activity_form_state.dart';
import 'package:weekplanner/features/weekplan/presentation/activity_form_cubit.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/pictogram_selector.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

class ActivityFormView extends StatelessWidget {
  const ActivityFormView({
    super.key,
    required this.title,
    required this.submitLabel,
  });

  final String title;
  final String submitLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocConsumer<ActivityFormCubit, ActivityFormState>(
        listener: (context, state) {
          if (state is ActivityFormSaved) {
            context.pop(true);
          }
        },
        builder: (context, state) {
          final isSaving = state is ActivityFormSaving;
          final error = state is ActivityFormReady ? state.error : null;
          final cubit = context.read<ActivityFormCubit>();
          return IgnorePointer(
            ignoring: isSaving,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pictogram selector (required)
                  Text(
                    'Piktogram',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const PictogramSelector(),
                  const SizedBox(height: 24),
                  // Title field
                  _TitleField(
                    title: state.form.title,
                    onChanged: cubit.setTitle,
                  ),
                  const SizedBox(height: 16),
                  // Date picker
                  _DatePicker(
                    date: state.form.date,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: state.form.date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && context.mounted) {
                        cubit.setDate(picked);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // Repeat selector (only for new activities)
                  if (!state.isEditing)
                    _RepeatDaySelector(
                      selectedDays: state.form.repeatDays,
                      onToggleDay: cubit.toggleRepeatDay,
                      onSelectWeekdays: cubit.setRepeatWeekdays,
                      onClear: cubit.clearRepeatDays,
                    ),
                  if (!state.isEditing) const SizedBox(height: 16),
                  // Time toggle
                  SwitchListTile(
                    title: const Text('Angiv tidspunkt'),
                    value: state.form.hasTime,
                    onChanged: (_) => cubit.toggleHasTime(),
                    contentPadding: EdgeInsets.zero,
                  ),
                  // Time pickers (only when enabled)
                  if (state.form.hasTime) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _TimePicker(
                            label: 'Starttid',
                            time: state.form.startTime,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: state.form.startTime.hour,
                                  minute: state.form.startTime.minute,
                                ),
                              );
                              if (picked != null && context.mounted) {
                                cubit.setStartTime(
                                  (hour: picked.hour, minute: picked.minute),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _TimePicker(
                            label: 'Sluttid',
                            time: state.form.endTime,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: state.form.endTime.hour,
                                  minute: state.form.endTime.minute,
                                ),
                              );
                              if (picked != null && context.mounted) {
                                cubit.setEndTime(
                                  (hour: picked.hour, minute: picked.minute),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        error,
                        style: TextStyle(color: context.colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ElevatedButton(
                    onPressed: isSaving
                        ? null
                        : () => cubit.save(),
                    child: isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(submitLabel),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Text field for the activity title.
///
/// Uses a [TextEditingController] to support bidirectional sync:
/// user edits update the cubit, and external changes (e.g., pictogram
/// selection auto-setting the title) update the text field.
class _TitleField extends StatefulWidget {
  const _TitleField({
    required this.title,
    required this.onChanged,
  });

  final String title;
  final ValueChanged<String> onChanged;

  @override
  State<_TitleField> createState() => _TitleFieldState();
}

class _TitleFieldState extends State<_TitleField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.title;
  }

  @override
  void didUpdateWidget(_TitleField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.title != oldWidget.title && widget.title != _controller.text) {
      _controller.text = widget.title;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: const InputDecoration(
        labelText: 'Titel',
        hintText: 'Giv aktiviteten et navn',
        prefixIcon: Icon(Icons.edit_outlined),
      ),
      maxLength: 200,
      textCapitalization: TextCapitalization.sentences,
    );
  }
}

class _DatePicker extends StatelessWidget {
  const _DatePicker({
    required this.date,
    required this.onTap,
  });

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dayName = GirafDateUtils.dayName(date.weekday);
    final formatted = GirafDateUtils.formatDateDDMM(date);
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Dato',
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          '$dayName $formatted',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

class _RepeatDaySelector extends StatelessWidget {
  final Set<int> selectedDays;
  final ValueChanged<int> onToggleDay;
  final VoidCallback onSelectWeekdays;
  final VoidCallback onClear;

  const _RepeatDaySelector({
    required this.selectedDays,
    required this.onToggleDay,
    required this.onSelectWeekdays,
    required this.onClear,
  });

  static const _dayLabels = ['Man', 'Tir', 'Ons', 'Tor', 'Fre', 'Lør', 'Søn'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Gentag',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            if (selectedDays.isEmpty)
              TextButton(
                onPressed: onSelectWeekdays,
                child: const Text('Hverdage'),
              )
            else
              TextButton(
                onPressed: onClear,
                child: const Text('Ryd'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (index) {
            final weekday = index + 1;
            final isSelected = selectedDays.contains(weekday);
            return _DayChip(
              label: _dayLabels[index],
              isSelected: isSelected,
              onTap: () => onToggleDay(weekday),
            );
          }),
        ),
        if (selectedDays.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Oprettes på ${selectedDays.length} dage denne uge',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _TimePicker extends StatelessWidget {
  const _TimePicker({
    required this.label,
    required this.time,
    required this.onTap,
  });

  final String label;
  final TimeValue time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.access_time),
        ),
        child: Text(
          formatTimeValue(time),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
