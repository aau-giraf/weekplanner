import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/presentation/view_models/activity_form_view_model.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/pictogram_selector.dart';

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
      body: Consumer<ActivityFormViewModel>(
        builder: (context, vm, _) {
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
                        time: vm.startTime,
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: vm.startTime.hour,
                              minute: vm.startTime.minute,
                            ),
                          );
                          if (picked != null) {
                            vm.setStartTime(
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
                        time: vm.endTime,
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: vm.endTime.hour,
                              minute: vm.endTime.minute,
                            ),
                          );
                          if (picked != null) {
                            vm.setEndTime(
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
                PictogramSelector(viewModel: vm),
                const SizedBox(height: 24),
                if (vm.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      vm.error!,
                      style: const TextStyle(color: GirafColors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ElevatedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                          final success = await vm.save();
                          if (success && context.mounted) {
                            context.pop();
                          }
                        },
                  child: vm.isLoading
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
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
