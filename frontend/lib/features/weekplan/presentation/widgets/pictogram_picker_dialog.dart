import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/domain/repositories/pictogram_repository.dart';
import 'package:weekplanner/shared/models/pictogram.dart';

/// Simplified pictogram search dialog for picking a pictogram.
///
/// Returns the selected [Pictogram], or null if dismissed.
class PictogramPickerDialog extends StatefulWidget {
  const PictogramPickerDialog({super.key});

  @override
  State<PictogramPickerDialog> createState() => _PictogramPickerDialogState();
}

class _PictogramPickerDialogState extends State<PictogramPickerDialog> {
  final _searchController = TextEditingController();
  List<Pictogram> _results = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) return;
    setState(() => _isSearching = true);

    final repo = context.read<PictogramRepository>();
    final result = await repo.searchPictograms(query);

    if (!mounted) return;
    setState(() {
      _isSearching = false;
      result.fold(
        (_) => _results = [],
        (pictograms) => _results = pictograms,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: GirafRadii.cardRadius),
      backgroundColor: GirafColors.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 560),
        child: Padding(
          padding: const EdgeInsets.all(GirafSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Vælg piktogram',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: GirafSpacing.md),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Søg piktogram',
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: _search,
                textInputAction: TextInputAction.search,
              ),
              const SizedBox(height: GirafSpacing.md),
              Flexible(
                child: _isSearching
                    ? const Center(child: CircularProgressIndicator())
                    : _results.isEmpty
                        ? Center(
                            child: Text(
                              'Søg for at finde piktogrammer',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: GirafSpacing.sm,
                              crossAxisSpacing: GirafSpacing.sm,
                            ),
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              final pictogram = _results[index];
                              return _PictogramGridItem(
                                pictogram: pictogram,
                                onTap: () =>
                                    Navigator.of(context).pop(pictogram),
                              );
                            },
                          ),
              ),
              const SizedBox(height: GirafSpacing.sm),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Annuller'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PictogramGridItem extends StatelessWidget {
  final Pictogram pictogram;
  final VoidCallback onTap;

  const _PictogramGridItem({
    required this.pictogram,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(GirafRadii.input),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: GirafColors.peach,
              borderRadius: GirafRadii.inputRadius,
            ),
            clipBehavior: Clip.antiAlias,
            child: pictogram.imageUrl != null
                ? Image.network(
                    pictogram.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.image,
                      color: GirafColors.brownMuted,
                    ),
                  )
                : const Icon(
                    Icons.image,
                    color: GirafColors.brownMuted,
                  ),
          ),
          const SizedBox(height: GirafSpacing.xs),
          Text(
            pictogram.name,
            style: Theme.of(context).textTheme.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
