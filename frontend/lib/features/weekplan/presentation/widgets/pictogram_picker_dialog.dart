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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Vælg piktogram',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Søg efter piktogram...',
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: _search,
                textInputAction: TextInputAction.search,
              ),
              const SizedBox(height: 12),
              Flexible(
                child: _isSearching
                    ? const Center(child: CircularProgressIndicator())
                    : _results.isEmpty
                        ? Center(
                            child: Text(
                              'Søg for at finde piktogrammer',
                              style: TextStyle(
                                color: context.colorScheme.outline,
                              ),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
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
              const SizedBox(height: 8),
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
      borderRadius: BorderRadius.circular(GirafShape.radiusSmall),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: context.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(GirafShape.radiusSmall),
            ),
            clipBehavior: Clip.antiAlias,
            child: pictogram.imageUrl != null
                ? Image.network(
                    pictogram.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.image,
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                  )
                : Icon(
                    Icons.image,
                    color: context.colorScheme.onPrimaryContainer,
                  ),
          ),
          const SizedBox(height: 4),
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
