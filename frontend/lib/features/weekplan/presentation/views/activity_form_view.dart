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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                            context.read<ActivityFormCubit>().setStartTime(
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
                            context.read<ActivityFormCubit>().setEndTime(
                                  (hour: picked.hour, minute: picked.minute),
                                );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Piktogram',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const PictogramSelector(),
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
                      : () => context.read<ActivityFormCubit>().save(),
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
          );
        },
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
