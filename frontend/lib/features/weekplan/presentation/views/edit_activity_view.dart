import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/presentation/view_models/activity_form_view_model.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/pictogram_selector.dart';

class EditActivityView extends StatelessWidget {
  const EditActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rediger aktivitet'),
      ),
      body: Consumer<ActivityFormViewModel>(
        builder: (context, vm, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Time pickers
                Row(
                  children: [
                    Expanded(
                      child: _TimePicker(
                        label: 'Starttid',
                        time: vm.startTime,
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: vm.startTime,
                          );
                          if (picked != null) vm.setStartTime(picked);
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
                            initialTime: vm.endTime,
                          );
                          if (picked != null) vm.setEndTime(picked);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Pictogram selector
                Text(
                  'Piktogram',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                PictogramSelector(
                  pictograms: vm.searchResults,
                  isLoading: vm.isSearching,
                  selectedId: vm.selectedPictogramId,
                  onSelect: vm.selectPictogram,
                  onSearch: vm.searchPictograms,
                ),
                const SizedBox(height: 24),

                // Error
                if (vm.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      vm.error!,
                      style: const TextStyle(color: GirafColors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Submit
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
                      : const Text('Gem ændringer'),
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
  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;

  const _TimePicker({
    required this.label,
    required this.time,
    required this.onTap,
  });

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
