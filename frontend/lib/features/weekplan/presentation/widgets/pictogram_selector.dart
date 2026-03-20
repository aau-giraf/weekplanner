import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/config/api_config.dart';
import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/presentation/view_models/activity_form_view_model.dart';
import 'package:weekplanner/shared/models/pictogram.dart';

class PictogramSelector extends StatefulWidget {
  final ActivityFormViewModel viewModel;

  const PictogramSelector({
    super.key,
    required this.viewModel,
  });

  @override
  State<PictogramSelector> createState() => _PictogramSelectorState();
}

class _PictogramSelectorState extends State<PictogramSelector> {
  final _searchController = TextEditingController();
  final _nameController = TextEditingController();
  final _promptController = TextEditingController();
  Timer? _debounce;

  ActivityFormViewModel get vm => widget.viewModel;

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _promptController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      vm.searchPictograms(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode tabs
        SegmentedButton<PictogramMode>(
          segments: const [
            ButtonSegment(
              value: PictogramMode.search,
              label: Text('Søg'),
              icon: Icon(Icons.search),
            ),
            ButtonSegment(
              value: PictogramMode.upload,
              label: Text('Upload'),
              icon: Icon(Icons.upload_file),
            ),
            ButtonSegment(
              value: PictogramMode.generate,
              label: Text('Generer'),
              icon: Icon(Icons.auto_awesome),
            ),
          ],
          selected: {vm.pictogramMode},
          onSelectionChanged: (modes) => vm.setPictogramMode(modes.first),
        ),
        const SizedBox(height: 12),

        // Content per mode
        if (vm.pictogramMode == PictogramMode.search)
          _SearchTab(
            controller: _searchController,
            onSearchChanged: _onSearchChanged,
            pictograms: vm.searchResults,
            isLoading: vm.isSearching,
            selectedId: vm.selectedPictogramId,
            onSelect: vm.selectPictogram,
          )
        else if (vm.pictogramMode == PictogramMode.upload)
          _UploadTab(viewModel: vm, nameController: _nameController)
        else
          _GenerateTab(
            viewModel: vm,
            nameController: _nameController,
            promptController: _promptController,
          ),

        // Selected pictogram preview
        if (vm.selectedPictogram != null) ...[
          const SizedBox(height: 12),
          _SelectedPictogramPreview(pictogram: vm.selectedPictogram!),
        ],
      ],
    );
  }
}

// ── Search tab (existing behavior) ──────────────────────────

class _SearchTab extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;
  final List<Pictogram> pictograms;
  final bool isLoading;
  final int? selectedId;
  final ValueChanged<Pictogram> onSelect;

  const _SearchTab({
    required this.controller,
    required this.onSearchChanged,
    required this.pictograms,
    required this.isLoading,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          onChanged: onSearchChanged,
          decoration: const InputDecoration(
            hintText: 'Søg piktogrammer...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 12),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (pictograms.isEmpty && controller.text.isNotEmpty)
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
              itemCount: pictograms.length,
              itemBuilder: (context, index) {
                final pictogram = pictograms[index];
                final isSelected = pictogram.id == selectedId;
                return GestureDetector(
                  onTap: () => onSelect(pictogram),
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
                            pictogram.name,
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

// ── Upload tab ──────────────────────────────────────────────

class _UploadTab extends StatelessWidget {
  final ActivityFormViewModel viewModel;
  final TextEditingController nameController;

  const _UploadTab({
    required this.viewModel,
    required this.nameController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: nameController,
          onChanged: viewModel.setPictogramName,
          decoration: const InputDecoration(
            labelText: 'Navn',
            hintText: 'Giv piktogrammet et navn...',
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            final file = await _pickFile(['jpg', 'jpeg', 'png', 'webp']);
            if (file != null) viewModel.setSelectedImageFile(file);
          },
          icon: const Icon(Icons.image),
          label: Text(viewModel.selectedImageFile != null
              ? viewModel.selectedImageFile!.name
              : 'Vælg billede'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () async {
            final file = await _pickFile(['mp3']);
            if (file != null) viewModel.setSelectedSoundFile(file);
          },
          icon: const Icon(Icons.audiotrack),
          label: Text(viewModel.selectedSoundFile != null
              ? viewModel.selectedSoundFile!.name
              : 'Vælg lydfil (valgfrit)'),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Generer lyd automatisk'),
          subtitle: const Text('AI-genereret udtale af navnet'),
          value: viewModel.generateSound,
          onChanged: viewModel.setGenerateSound,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: viewModel.isCreatingPictogram
              ? null
              : () => viewModel.uploadPictogramFromFile(),
          child: viewModel.isCreatingPictogram
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Upload piktogram'),
        ),
      ],
    );
  }

  Future<PlatformFile?> _pickFile(List<String> extensions) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
      withData: true,
    );
    return result?.files.single;
  }
}

// ── Generate tab ────────────────────────────────────────────

class _GenerateTab extends StatelessWidget {
  final ActivityFormViewModel viewModel;
  final TextEditingController nameController;
  final TextEditingController promptController;

  const _GenerateTab({
    required this.viewModel,
    required this.nameController,
    required this.promptController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: nameController,
          onChanged: viewModel.setPictogramName,
          decoration: const InputDecoration(
            labelText: 'Navn',
            hintText: 'Giv piktogrammet et navn...',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: promptController,
          onChanged: viewModel.setGeneratePrompt,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Beskrivelse til AI (valgfrit)',
            hintText: 'Beskriv hvad billedet skal vise...',
            helperText: 'Lad feltet stå tomt for at bruge navnet som beskrivelse',
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Generer lyd'),
          subtitle: const Text('AI-genereret udtale af navnet'),
          value: viewModel.generateSound,
          onChanged: viewModel.setGenerateSound,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: viewModel.isCreatingPictogram
              ? null
              : () => viewModel.generatePictogram(),
          icon: viewModel.isCreatingPictogram
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.auto_awesome),
          label: const Text('Generer piktogram'),
        ),
      ],
    );
  }
}

// ── Selected pictogram preview ──────────────────────────────

class _SelectedPictogramPreview extends StatelessWidget {
  final Pictogram pictogram;

  const _SelectedPictogramPreview({required this.pictogram});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: GirafColors.lightGray,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: GirafColors.orange, width: 2),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              ApiConfig.pictogramImageUrl(pictogram.id),
              width: 48,
              height: 48,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) =>
                  const Icon(Icons.image, size: 48, color: GirafColors.gray),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pictogram.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (pictogram.soundUrl != null && pictogram.soundUrl!.isNotEmpty)
                  const Text(
                    'Med lyd',
                    style: TextStyle(fontSize: 12, color: GirafColors.gray),
                  ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: GirafColors.orange),
        ],
      ),
    );
  }
}
