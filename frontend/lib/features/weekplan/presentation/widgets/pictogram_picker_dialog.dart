import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' show Either, Left, Right;

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/core/errors/pictogram_failure.dart';
import 'package:weekplanner/features/weekplan/domain/activity_form_state.dart';
import 'package:weekplanner/features/weekplan/domain/repositories/pictogram_repository.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/pictogram_file_pickers.dart';
import 'package:weekplanner/shared/models/file_data.dart';
import 'package:weekplanner/shared/models/pictogram.dart';

/// Pictogram picker dialog with search, upload, and AI-generate modes.
///
/// Returns the selected or newly created [Pictogram], or null if dismissed.
class PictogramPickerDialog extends StatefulWidget {
  /// Organization to create new pictograms under.
  final int? organizationId;

  /// Overridable file pickers for testing; default to the platform picker.
  final Future<FileData?> Function()? pickImageFile;
  final Future<FileData?> Function()? pickSoundFile;

  const PictogramPickerDialog({
    super.key,
    this.organizationId,
    this.pickImageFile,
    this.pickSoundFile,
  });

  @override
  State<PictogramPickerDialog> createState() => _PictogramPickerDialogState();
}

class _PictogramPickerDialogState extends State<PictogramPickerDialog> {
  final _searchController = TextEditingController();
  final _nameController = TextEditingController();

  PictogramMode _mode = PictogramMode.search;
  List<Pictogram> _results = [];
  bool _isSearching = false;

  FileData? _imageFile;
  FileData? _soundFile;
  bool _generateSound = true;
  bool _isCreating = false;
  String? _error;

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
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

  Future<void> _pickImage() async {
    final picker = widget.pickImageFile ?? pickImageFileFromDevice;
    final file = await picker();
    if (file != null && mounted) setState(() => _imageFile = file);
  }

  Future<void> _pickSound() async {
    final picker = widget.pickSoundFile ?? pickSoundFileFromDevice;
    final file = await picker();
    if (file != null && mounted) setState(() => _soundFile = file);
  }

  Future<void> _upload() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Angiv et navn');
      return;
    }
    final imageFile = _imageFile;
    if (imageFile == null) {
      setState(() => _error = 'Vælg et billede');
      return;
    }
    setState(() {
      _isCreating = true;
      _error = null;
    });

    final repo = context.read<PictogramRepository>();
    final result = await repo.uploadPictogram(
      name: name,
      imageFile: imageFile,
      soundFile: _soundFile,
      organizationId: widget.organizationId,
      generateSound: _generateSound,
    );

    if (!mounted) return;
    _finishCreation(result);
  }

  Future<void> _generate() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Angiv et navn');
      return;
    }
    setState(() {
      _isCreating = true;
      _error = null;
    });

    final repo = context.read<PictogramRepository>();
    final result = await repo.createPictogram(
      name: name,
      organizationId: widget.organizationId,
      generateImage: true,
      generateSound: _generateSound,
    );

    if (!mounted) return;
    _finishCreation(result);
  }

  void _finishCreation(Either<PictogramFailure, Pictogram> result) {
    switch (result) {
      case Left(:final value):
        setState(() {
          _isCreating = false;
          _error = value.message;
        });
      case Right(:final value):
        Navigator.of(context).pop(value);
    }
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
                selected: {_mode},
                onSelectionChanged: (modes) => setState(() {
                  _mode = modes.first;
                  _error = null;
                }),
              ),
              const SizedBox(height: GirafSpacing.md),
              Flexible(
                child: switch (_mode) {
                  PictogramMode.search => _SearchContent(
                      controller: _searchController,
                      onSubmitted: _search,
                      isSearching: _isSearching,
                      results: _results,
                      onSelect: (pictogram) =>
                          Navigator.of(context).pop(pictogram),
                    ),
                  PictogramMode.upload => _CreationContent(
                      nameController: _nameController,
                      generateSound: _generateSound,
                      generateSoundLabel: 'Generer lyd automatisk',
                      isCreating: _isCreating,
                      submitLabel: 'Opret piktogram',
                      onGenerateSoundChanged: (value) =>
                          setState(() => _generateSound = value),
                      onSubmit: _upload,
                      filePickers: _FilePickerButtons(
                        imageFile: _imageFile,
                        soundFile: _soundFile,
                        onPickImage: _pickImage,
                        onPickSound: _pickSound,
                      ),
                    ),
                  PictogramMode.generate => _CreationContent(
                      nameController: _nameController,
                      generateSound: _generateSound,
                      generateSoundLabel: 'Generer lyd',
                      isCreating: _isCreating,
                      submitLabel: 'Generer piktogram',
                      onGenerateSoundChanged: (value) =>
                          setState(() => _generateSound = value),
                      onSubmit: _generate,
                    ),
                },
              ),
              if (_error != null) ...[
                const SizedBox(height: GirafSpacing.sm),
                Text(
                  _error!,
                  style: TextStyle(color: context.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ],
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

// ── Search mode ───────────────────────────────────────────────

class _SearchContent extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final bool isSearching;
  final List<Pictogram> results;
  final ValueChanged<Pictogram> onSelect;

  const _SearchContent({
    required this.controller,
    required this.onSubmitted,
    required this.isSearching,
    required this.results,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Søg piktogram',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.search,
        ),
        const SizedBox(height: GirafSpacing.md),
        Flexible(
          child: isSearching
              ? const Center(child: CircularProgressIndicator())
              : results.isEmpty
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
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final pictogram = results[index];
                        return _PictogramGridItem(
                          pictogram: pictogram,
                          onTap: () => onSelect(pictogram),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

// ── Upload / generate modes ───────────────────────────────────

/// Shared layout for the upload and generate modes: name field,
/// optional file-picker buttons, sound toggle, and submit button.
class _CreationContent extends StatelessWidget {
  final TextEditingController nameController;
  final bool generateSound;
  final String generateSoundLabel;
  final bool isCreating;
  final String submitLabel;
  final ValueChanged<bool> onGenerateSoundChanged;
  final VoidCallback onSubmit;
  final Widget? filePickers;

  const _CreationContent({
    required this.nameController,
    required this.generateSound,
    required this.generateSoundLabel,
    required this.isCreating,
    required this.submitLabel,
    required this.onGenerateSoundChanged,
    required this.onSubmit,
    this.filePickers,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Navn',
              hintText: 'Navn på piktogrammet',
              prefixIcon: Icon(Icons.edit_outlined),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: GirafSpacing.sm),
          if (filePickers != null) ...[
            filePickers!,
            const SizedBox(height: GirafSpacing.sm),
          ],
          SwitchListTile(
            title: Text(generateSoundLabel),
            subtitle: const Text('AI-genereret udtale af navnet'),
            value: generateSound,
            onChanged: onGenerateSoundChanged,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: GirafSpacing.sm),
          FilledButton.icon(
            onPressed: isCreating ? null : onSubmit,
            icon: isCreating
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome),
            label: Text(submitLabel),
          ),
        ],
      ),
    );
  }
}

class _FilePickerButtons extends StatelessWidget {
  final FileData? imageFile;
  final FileData? soundFile;
  final VoidCallback onPickImage;
  final VoidCallback onPickSound;

  const _FilePickerButtons({
    required this.imageFile,
    required this.soundFile,
    required this.onPickImage,
    required this.onPickSound,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: onPickImage,
          icon: const Icon(Icons.image),
          label: Text(imageFile != null ? imageFile!.name : 'Vælg billede'),
        ),
        const SizedBox(height: GirafSpacing.sm),
        OutlinedButton.icon(
          onPressed: onPickSound,
          icon: const Icon(Icons.audiotrack),
          label: Text(
            soundFile != null ? soundFile!.name : 'Vælg lydfil (valgfrit)',
          ),
        ),
      ],
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
