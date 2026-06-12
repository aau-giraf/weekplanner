import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/domain/activity_form_state.dart';
import 'package:weekplanner/features/weekplan/presentation/activity_form_cubit.dart';
import 'package:weekplanner/features/weekplan/domain/repositories/pictogram_repository.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/pictogram_picker_dialog.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/pictogram_selector.dart';
import 'package:weekplanner/shared/models/pictogram.dart';
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
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    maxWidth: GirafLayout.maxContentWidth),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(GirafSpacing.xl),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left column: pictogram / choice options
                      Expanded(
                        flex: 45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (!state.isEditing)
                              SwitchListTile(
                                title: const Text('Aktivitetsvælger'),
                                subtitle: state.form.isChoiceActivity
                                    ? const Text(
                                        'Barnet vælger mellem muligheder')
                                    : null,
                                value: state.form.isChoiceActivity,
                                onChanged: (_) =>
                                    cubit.toggleChoiceActivity(),
                                contentPadding: EdgeInsets.zero,
                              ),
                            if (!state.isEditing)
                              const SizedBox(height: GirafSpacing.sm),
                            if (state.form.isChoiceActivity)
                              _ChoiceOptionsEditor(
                                options: state.form.choiceOptions,
                                cubit: cubit,
                              )
                            else ...[
                              Text(
                                'Piktogram',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge,
                              ),
                              const SizedBox(height: GirafSpacing.sm),
                              const PictogramSelector(),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: GirafSpacing.xxl),
                      // Right column: form fields
                      Expanded(
                        flex: 55,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _TitleField(
                              title: state.form.title,
                              onChanged: cubit.setTitle,
                            ),
                            const SizedBox(height: GirafSpacing.lg),
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
                            const SizedBox(height: GirafSpacing.lg),
                            if (!state.isEditing)
                              _RepeatDaySelector(
                                selectedDays: state.form.repeatDays,
                                onToggleDay: cubit.toggleRepeatDay,
                                onSelectWeekdays:
                                    cubit.setRepeatWeekdays,
                                onClear: cubit.clearRepeatDays,
                              ),
                            if (!state.isEditing)
                              const SizedBox(height: GirafSpacing.lg),
                            SwitchListTile(
                              title: const Text('Angiv tidspunkt'),
                              value: state.form.hasTime,
                              onChanged: (_) => cubit.toggleHasTime(),
                              contentPadding: EdgeInsets.zero,
                            ),
                            if (state.form.hasTime) ...[
                              const SizedBox(height: GirafSpacing.sm),
                              Row(
                                children: [
                                  Expanded(
                                    child: _TimePicker(
                                      label: 'Starttid',
                                      time: state.form.startTime,
                                      onTap: () async {
                                        final picked =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay(
                                            hour: state
                                                .form.startTime.hour,
                                            minute: state
                                                .form.startTime.minute,
                                          ),
                                        );
                                        if (picked != null &&
                                            context.mounted) {
                                          cubit.setStartTime((
                                            hour: picked.hour,
                                            minute: picked.minute,
                                          ));
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: GirafSpacing.lg),
                                  Expanded(
                                    child: _TimePicker(
                                      label: 'Sluttid',
                                      time: state.form.endTime,
                                      onTap: () async {
                                        final picked =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay(
                                            hour:
                                                state.form.endTime.hour,
                                            minute: state
                                                .form.endTime.minute,
                                          ),
                                        );
                                        if (picked != null &&
                                            context.mounted) {
                                          cubit.setEndTime((
                                            hour: picked.hour,
                                            minute: picked.minute,
                                          ));
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: GirafSpacing.xl),
                            if (error != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: GirafSpacing.lg,
                                ),
                                child: Text(
                                  error,
                                  style: TextStyle(
                                      color: context.colorScheme.error),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            FilledButton(
                              onPressed: isSaving
                                  ? null
                                  : () => cubit.save(),
                              child: isSaving
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child:
                                          CircularProgressIndicator(
                                              strokeWidth: 2),
                                    )
                                  : Text(submitLabel),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
              style: Theme.of(context).textTheme.titleLarge,
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
        const SizedBox(height: GirafSpacing.sm),
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
            padding: const EdgeInsets.only(top: GirafSpacing.sm),
            child: Text(
              'Oprettes på ${selectedDays.length} dage denne uge',
              style: Theme.of(context).textTheme.bodySmall,
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: AnimatedContainer(
          duration: GirafMotion.dayChip,
          curve: GirafMotion.standard,
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? GirafColors.primaryOrange : GirafColors.peach,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            label.substring(0, 1),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : GirafColors.brownDark,
                ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceOptionsEditor extends StatelessWidget {
  final List<ChoiceOptionData> options;
  final ActivityFormCubit cubit;

  const _ChoiceOptionsEditor({
    required this.options,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Valgmuligheder',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: GirafSpacing.sm),
        ...options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          return _ChoiceOptionSlot(
            index: index,
            option: option,
            canRemove: options.length > 2,
            onTitleChanged: (title) =>
                cubit.setChoiceOptionTitle(index, title),
            onPickPictogram: () async {
              final repo = context.read<PictogramRepository>();
              final picked = await showDialog<Pictogram>(
                context: context,
                builder: (_) => RepositoryProvider.value(
                  value: repo,
                  child: PictogramPickerDialog(
                    organizationId: cubit.organizationId,
                  ),
                ),
              );
              if (picked != null) {
                cubit.setChoiceOptionPictogram(index, picked.id, picked.name);
              }
            },
            onRemove: () => cubit.removeChoiceOption(index),
          );
        }),
        if (options.length < 3)
          Padding(
            padding: const EdgeInsets.only(top: GirafSpacing.sm),
            child: OutlinedButton.icon(
              onPressed: cubit.addChoiceOption,
              icon: const Icon(Icons.add),
              label: const Text('Tilføj valgmulighed'),
            ),
          ),
      ],
    );
  }
}

class _ChoiceOptionSlot extends StatelessWidget {
  final int index;
  final ChoiceOptionData option;
  final bool canRemove;
  final ValueChanged<String> onTitleChanged;
  final VoidCallback onPickPictogram;
  final VoidCallback onRemove;

  const _ChoiceOptionSlot({
    required this.index,
    required this.option,
    required this.canRemove,
    required this.onTitleChanged,
    required this.onPickPictogram,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: GirafSpacing.sm),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: GirafColors.surface,
          borderRadius: GirafRadii.cardRadius,
          boxShadow: GirafElevation.card,
        ),
        child: Padding(
          padding: const EdgeInsets.all(GirafSpacing.md),
          child: Row(
            children: [
              // Pictogram thumbnail / pick button
              GestureDetector(
                onTap: onPickPictogram,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: GirafColors.peach,
                    borderRadius: GirafRadii.inputRadius,
                    border: option.pictogramId == null
                        ? Border.all(color: GirafColors.outline)
                        : null,
                  ),
                  child: option.pictogramId != null
                      ? const Icon(Icons.check,
                          color: GirafColors.primaryOrange)
                      : const Icon(Icons.add_photo_alternate,
                          color: GirafColors.brownMuted),
                ),
              ),
              const SizedBox(width: GirafSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mulighed ${index + 1}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    if (option.pictogramName != null)
                      Text(
                        option.pictogramName!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: GirafColors.orangeDeep,
                              fontWeight: FontWeight.w700,
                            ),
                      )
                    else
                      TextButton(
                        onPressed: onPickPictogram,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Vælg piktogram'),
                      ),
                  ],
                ),
              ),
              if (canRemove)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onRemove,
                ),
            ],
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
