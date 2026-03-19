import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weekplanner/config/api_config.dart';
import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/shared/models/pictogram.dart';

class PictogramSelector extends StatefulWidget {
  final List<Pictogram> pictograms;
  final bool isLoading;
  final int? selectedId;
  final ValueChanged<Pictogram> onSelect;
  final ValueChanged<String> onSearch;

  const PictogramSelector({
    super.key,
    required this.pictograms,
    required this.isLoading,
    required this.selectedId,
    required this.onSelect,
    required this.onSearch,
  });

  @override
  State<PictogramSelector> createState() => _PictogramSelectorState();
}

class _PictogramSelectorState extends State<PictogramSelector> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      widget.onSearch(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          onChanged: _onSearchChanged,
          decoration: const InputDecoration(
            hintText: 'Søg piktogrammer...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 12),
        if (widget.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (widget.pictograms.isEmpty && _controller.text.isNotEmpty)
          const Center(child: Text('Ingen piktogrammer fundet'))
        else
          SizedBox(
            height: 200,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: widget.pictograms.length,
              itemBuilder: (context, index) {
                final pictogram = widget.pictograms[index];
                final isSelected = pictogram.id == widget.selectedId;
                return GestureDetector(
                  onTap: () => widget.onSelect(pictogram),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? GirafColors.orange : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: GirafColors.lightGray,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Image.network(
                              ApiConfig.pictogramImageUrl(pictogram.id),
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) =>
                                  const Icon(Icons.image, color: GirafColors.gray),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            pictogram.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
