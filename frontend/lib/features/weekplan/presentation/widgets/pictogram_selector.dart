import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/domain/activity_form_state.dart';
import 'package:weekplanner/features/weekplan/presentation/activity_form_cubit.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/pictogram_file_pickers.dart';
import 'package:weekplanner/shared/models/file_data.dart';
import 'package:weekplanner/shared/models/pictogram.dart';

class PictogramSelector extends StatefulWidget {
  const PictogramSelector({super.key});

  @override
  State<PictogramSelector> createState() => _PictogramSelectorState();
}

class _PictogramSelectorState extends State<PictogramSelector> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
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
            const SizedBox(height: GirafSpacing.md),

            // Content per mode
            switch (state.creation.mode) {
              PictogramMode.search => _SearchTab(
                  controller: _searchController,
                  onSearchChanged: cubit.onSearchQueryChanged,
                  pictograms: state.search.results,
                  isLoading: state.search.isSearching,
                  selectedId: state.selection.id,
                  onSelect: cubit.selectPictogram,
                ),
              PictogramMode.upload => _UploadTab(
                  selectedImageFile: state.creation.imageFile,
                  selectedSoundFile: state.creation.soundFile,
                  generateSound: state.creation.generateSound,
                  onImageFilePicked: cubit.setSelectedImageFile,
                  onSoundFilePicked: cubit.setSelectedSoundFile,
                  onGenerateSoundChanged: cubit.setGenerateSound,
                ),
              PictogramMode.generate => _GenerateTab(
                  generateSound: state.creation.generateSound,
                  isCreatingPictogram: state.creation.isCreating,
                  onGenerateSoundChanged: cubit.setGenerateSound,
                  onGenerate: cubit.generatePictogram,
                ),
            },

            // Selected pictogram preview
            if (state.selection.pictogram != null) ...[
              const SizedBox(height: GirafSpacing.md),
              // Guarded by != null check above.
              _SelectedPictogramPreview(pictogram: state.selection.pictogram!),
            ],
          ],
        );
      },
    );
  }
}

// ── Search tab ────────────────────────────────────────────────

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
            hintText: 'Søg piktogram',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: GirafSpacing.md),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (pictograms.isEmpty && controller.text.isNotEmpty)
          const Center(child: Text('Ingen piktogrammer fundet'))
        else
          SizedBox(
            height: 240,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: GirafSpacing.sm,
                mainAxisSpacing: GirafSpacing.sm,
              ),
              itemCount: pictograms.length,
              itemBuilder: (context, index) {
                final pictogram = pictograms[index];
                final isSelected = pictogram.id == selectedId;
                return _PictogramGridTile(
                  pictogram: pictogram,
                  isSelected: isSelected,
                  onTap: () => onSelect(pictogram),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _PictogramGridTile extends StatelessWidget {
  final Pictogram pictogram;
  final bool isSelected;
  final VoidCallback onTap;

  const _PictogramGridTile({
    required this.pictogram,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: GirafRadii.inputRadius,
        child: AnimatedContainer(
          duration: GirafMotion.activityTick,
          curve: GirafMotion.standard,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? GirafColors.primaryOrange : Colors.transparent,
              width: 3,
            ),
            borderRadius: GirafRadii.inputRadius,
            color: GirafColors.peach,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(GirafSpacing.xs),
                  child: pictogram.imageUrl != null
                      ? Image.network(
                          pictogram.imageUrl!,
                          fit: BoxFit.contain,
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: GirafSpacing.xs,
                  vertical: GirafSpacing.xs,
                ),
                child: Text(
                  pictogram.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: GirafColors.brownDark,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Upload tab ────────────────────────────────────────────────

/// Simplified upload tab: pick image, optionally pick sound or toggle
/// auto-generation. No separate name field — the activity title (set in
/// the form below) is used as the pictogram name on submit.
class _UploadTab extends StatelessWidget {
  final FileData? selectedImageFile;
  final FileData? selectedSoundFile;
  final bool generateSound;
  final ValueChanged<FileData?> onImageFilePicked;
  final ValueChanged<FileData?> onSoundFilePicked;
  final ValueChanged<bool> onGenerateSoundChanged;

  const _UploadTab({
    required this.selectedImageFile,
    required this.selectedSoundFile,
    required this.generateSound,
    required this.onImageFilePicked,
    required this.onSoundFilePicked,
    required this.onGenerateSoundChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: () async {
            final file = await pickImageFileFromDevice();
            if (file != null) onImageFilePicked(file);
          },
          icon: const Icon(Icons.image),
          label: Text(
            selectedImageFile != null
                ? selectedImageFile!.name
                : 'Vælg billede',
          ),
        ),
        const SizedBox(height: GirafSpacing.sm),
        OutlinedButton.icon(
          onPressed: () async {
            final file = await pickSoundFileFromDevice();
            if (file != null) onSoundFilePicked(file);
          },
          icon: const Icon(Icons.audiotrack),
          label: Text(
            selectedSoundFile != null
                ? selectedSoundFile!.name
                : 'Vælg lydfil (valgfrit)',
          ),
        ),
        const SizedBox(height: GirafSpacing.sm),
        SwitchListTile(
          title: const Text('Generer lyd automatisk'),
          subtitle: const Text('AI-genereret udtale af titlen'),
          value: generateSound,
          onChanged: onGenerateSoundChanged,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

}

// ── Generate tab ──────────────────────────────────────────────

/// AI generation tab: optional prompt and sound toggle. The pictogram
/// name comes from the activity title field — no separate name input.
class _GenerateTab extends StatelessWidget {
  final bool generateSound;
  final bool isCreatingPictogram;
  final ValueChanged<bool> onGenerateSoundChanged;
  final Future<bool> Function() onGenerate;

  const _GenerateTab({
    required this.generateSound,
    required this.isCreatingPictogram,
    required this.onGenerateSoundChanged,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          title: const Text('Generer lyd'),
          subtitle: const Text('AI-genereret udtale af titlen'),
          value: generateSound,
          onChanged: onGenerateSoundChanged,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: GirafSpacing.md),
        FilledButton.icon(
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

// ── Selected pictogram preview ────────────────────────────────

class _SelectedPictogramPreview extends StatelessWidget {
  final Pictogram pictogram;

  const _SelectedPictogramPreview({required this.pictogram});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(GirafSpacing.sm),
      decoration: BoxDecoration(
        color: GirafColors.surface,
        borderRadius: GirafRadii.inputRadius,
        border: Border.all(color: GirafColors.primaryOrange, width: 2),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(GirafSpacing.xs),
            child: pictogram.imageUrl != null
                ? Image.network(
                    pictogram.imageUrl!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.image,
                      size: 48,
                      color: GirafColors.brownMuted,
                    ),
                  )
                : const Icon(
                    Icons.image,
                    size: 48,
                    color: GirafColors.brownMuted,
                  ),
          ),
          const SizedBox(width: GirafSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pictogram.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                if (pictogram.soundUrl != null &&
                    pictogram.soundUrl!.isNotEmpty)
                  Text(
                    'Med lyd',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: GirafColors.primaryOrange),
        ],
      ),
    );
  }
}
