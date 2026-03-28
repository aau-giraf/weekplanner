import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/domain/activity_form_state.dart';
import 'package:weekplanner/features/weekplan/presentation/activity_form_cubit.dart';
import 'package:weekplanner/shared/models/pictogram.dart';

class PictogramSelector extends StatefulWidget {
  const PictogramSelector({super.key});

  @override
  State<PictogramSelector> createState() => _PictogramSelectorState();
}

class _PictogramSelectorState extends State<PictogramSelector> {
  final _searchController = TextEditingController();
  final _nameController = TextEditingController();
  final _promptController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityFormCubit, ActivityFormState>(
      builder: (context, state) {
        final cubit = context.read<ActivityFormCubit>();
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
              selected: {state.creation.mode},
              onSelectionChanged: (modes) =>
                  cubit.setPictogramMode(modes.first),
            ),
            const SizedBox(height: 12),

            // Content per mode
            _PictogramModeContent(
              mode: state.creation.mode,
              state: state,
              cubit: cubit,
              searchController: _searchController,
              nameController: _nameController,
              promptController: _promptController,
            ),

            // Selected pictogram preview
            if (state.selection.pictogram != null) ...[
              const SizedBox(height: 12),
              // Guarded by != null check above.
              _SelectedPictogramPreview(pictogram: state.selection.pictogram!),
            ],
          ],
        );
      },
    );
  }
}

// ── Search tab (existing behavior) ──────────────────────────

/// Renders the appropriate tab content based on the selected [PictogramMode].
class _PictogramModeContent extends StatelessWidget {
  const _PictogramModeContent({
    required this.mode,
    required this.state,
    required this.cubit,
    required this.searchController,
    required this.nameController,
    required this.promptController,
  });

  final PictogramMode mode;
  final ActivityFormState state;
  final ActivityFormCubit cubit;
  final TextEditingController searchController;
  final TextEditingController nameController;
  final TextEditingController promptController;

  @override
  Widget build(BuildContext context) {
    return switch (mode) {
      PictogramMode.search => _SearchTab(
          controller: searchController,
          onSearchChanged: cubit.onSearchQueryChanged,
          pictograms: state.search.results,
          isLoading: state.search.isSearching,
          selectedId: state.selection.id,
          onSelect: cubit.selectPictogram,
        ),
      PictogramMode.upload => _UploadTab(
          nameController: nameController,
          selectedImageFile: state.creation.imageFile,
          selectedSoundFile: state.creation.soundFile,
          generateSound: state.creation.generateSound,
          isCreatingPictogram: state.creation.isCreating,
          onNameChanged: cubit.setPictogramName,
          onImageFilePicked: cubit.setSelectedImageFile,
          onSoundFilePicked: cubit.setSelectedSoundFile,
          onGenerateSoundChanged: cubit.setGenerateSound,
          onUpload: cubit.uploadPictogramFromFile,
        ),
      PictogramMode.generate => _GenerateTab(
          nameController: nameController,
          promptController: promptController,
          generateSound: state.creation.generateSound,
          isCreatingPictogram: state.creation.isCreating,
          onNameChanged: cubit.setPictogramName,
          onPromptChanged: cubit.setGeneratePrompt,
          onGenerateSoundChanged: cubit.setGenerateSound,
          onGenerate: cubit.generatePictogram,
        ),
    };
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
                        color: isSelected
                            ? context.colorScheme.primary
                            : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: context.colorScheme.surfaceContainerLow,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: pictogram.imageUrl != null
                                ? Image.network(
                                    pictogram.imageUrl!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, _, _) => Icon(
                                      Icons.image,
                                      color: context.colorScheme.outline,
                                    ),
                                  )
                                : Icon(
                                    Icons.image,
                                    color: context.colorScheme.outline,
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
  final TextEditingController nameController;
  final PlatformFile? selectedImageFile;
  final PlatformFile? selectedSoundFile;
  final bool generateSound;
  final bool isCreatingPictogram;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<PlatformFile?> onImageFilePicked;
  final ValueChanged<PlatformFile?> onSoundFilePicked;
  final ValueChanged<bool> onGenerateSoundChanged;
  final Future<bool> Function() onUpload;

  const _UploadTab({
    required this.nameController,
    required this.selectedImageFile,
    required this.selectedSoundFile,
    required this.generateSound,
    required this.isCreatingPictogram,
    required this.onNameChanged,
    required this.onImageFilePicked,
    required this.onSoundFilePicked,
    required this.onGenerateSoundChanged,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: nameController,
          onChanged: onNameChanged,
          decoration: const InputDecoration(
            labelText: 'Navn',
            hintText: 'Giv piktogrammet et navn...',
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            final file = await _pickFile(['jpg', 'jpeg', 'png', 'webp']);
            if (file != null) onImageFilePicked(file);
          },
          icon: const Icon(Icons.image),
          label: Text(
            selectedImageFile != null
                ? selectedImageFile!.name
                : 'Vælg billede',
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () async {
            final file = await _pickFile(['mp3']);
            if (file != null) onSoundFilePicked(file);
          },
          icon: const Icon(Icons.audiotrack),
          label: Text(
            selectedSoundFile != null
                ? selectedSoundFile!.name
                : 'Vælg lydfil (valgfrit)',
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Generer lyd automatisk'),
          subtitle: const Text('AI-genereret udtale af navnet'),
          value: generateSound,
          onChanged: onGenerateSoundChanged,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: isCreatingPictogram ? null : onUpload,
          child: isCreatingPictogram
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
  final TextEditingController nameController;
  final TextEditingController promptController;
  final bool generateSound;
  final bool isCreatingPictogram;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onPromptChanged;
  final ValueChanged<bool> onGenerateSoundChanged;
  final Future<bool> Function() onGenerate;

  const _GenerateTab({
    required this.nameController,
    required this.promptController,
    required this.generateSound,
    required this.isCreatingPictogram,
    required this.onNameChanged,
    required this.onPromptChanged,
    required this.onGenerateSoundChanged,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: nameController,
          onChanged: onNameChanged,
          decoration: const InputDecoration(
            labelText: 'Navn',
            hintText: 'Giv piktogrammet et navn...',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: promptController,
          onChanged: onPromptChanged,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Beskrivelse til AI (valgfrit)',
            hintText: 'Beskriv hvad billedet skal vise...',
            helperText:
                'Lad feltet stå tomt for at bruge navnet som beskrivelse',
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Generer lyd'),
          subtitle: const Text('AI-genereret udtale af navnet'),
          value: generateSound,
          onChanged: onGenerateSoundChanged,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: isCreatingPictogram ? null : onGenerate,
          icon: isCreatingPictogram
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
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colorScheme.primary, width: 2),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: pictogram.imageUrl != null
                ? Image.network(
                    pictogram.imageUrl!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.image,
                      size: 48,
                      color: context.colorScheme.outline,
                    ),
                  )
                : Icon(
                    Icons.image,
                    size: 48,
                    color: context.colorScheme.outline,
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
                if (pictogram.soundUrl != null &&
                    pictogram.soundUrl!.isNotEmpty)
                  Text(
                    'Med lyd',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.colorScheme.outline,
                    ),
                  ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: context.colorScheme.primary),
        ],
      ),
    );
  }
}
