import 'package:flutter/material.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/domain/weekplan_state.dart';
import 'package:weekplanner/shared/models/activity.dart';

/// Full-screen dialog for selecting an option on a choice activity.
///
/// Returns the selected option index, or null if dismissed.
class ChoiceSelectorDialog extends StatelessWidget {
  final Activity activity;
  final Map<int, PictogramMedia> pictogramMedia;

  const ChoiceSelectorDialog({
    super.key,
    required this.activity,
    required this.pictogramMedia,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hvad vil du lave?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            ...activity.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final media = option.pictogramId != null
                  ? pictogramMedia[option.pictogramId!]
                  : null;
              return _OptionCard(
                option: option,
                imageUrl: media?.imageUrl,
                onTap: () => Navigator.of(context).pop(index),
              );
            }),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuller'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final ActivityOption option;
  final String? imageUrl;
  final VoidCallback onTap;

  const _OptionCard({
    required this.option,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(GirafRadii.input),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.image,
                            size: 32,
                            color: context.colorScheme.onPrimaryContainer,
                          ),
                        )
                      : Icon(
                          Icons.image,
                          size: 32,
                          color: context.colorScheme.onPrimaryContainer,
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option.title ?? 'Unavngivet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: context.colorScheme.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
