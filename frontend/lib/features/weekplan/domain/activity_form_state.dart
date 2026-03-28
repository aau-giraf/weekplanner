import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/models/pictogram.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

/// Mode for how the user is adding a pictogram.
enum PictogramMode { search, upload, generate }

/// State managed by [ActivityFormCubit].
sealed class ActivityFormState extends Equatable {
  /// Start time of the activity.
  final TimeValue startTime;

  /// End time of the activity.
  final TimeValue endTime;

  /// Date of the activity.
  final DateTime date;

  /// ID of the selected pictogram, if any.
  final int? selectedPictogramId;

  /// Full pictogram object, if selected.
  final Pictogram? selectedPictogram;

  /// The activity being edited, or null for new activities.
  final Activity? existingActivity;

  /// Current pictogram selection mode.
  final PictogramMode pictogramMode;

  /// Name for a new pictogram being created.
  final String pictogramName;

  /// AI generation prompt for a new pictogram.
  final String generatePrompt;

  /// Selected image file for upload mode.
  final PlatformFile? selectedImageFile;

  /// Selected sound file for upload mode.
  final PlatformFile? selectedSoundFile;

  /// Whether to auto-generate sound for new pictograms.
  final bool generateSound;

  /// Whether a pictogram creation operation is in progress.
  final bool isCreatingPictogram;

  /// Current pictogram search results.
  final List<Pictogram> searchResults;

  /// Whether a pictogram search is in progress.
  final bool isSearching;

  const ActivityFormState({
    this.startTime = const (hour: 8, minute: 0),
    this.endTime = const (hour: 9, minute: 0),
    required this.date,
    this.selectedPictogramId,
    this.selectedPictogram,
    this.existingActivity,
    this.pictogramMode = PictogramMode.search,
    this.pictogramName = '',
    this.generatePrompt = '',
    this.selectedImageFile,
    this.selectedSoundFile,
    this.generateSound = true,
    this.isCreatingPictogram = false,
    this.searchResults = const [],
    this.isSearching = false,
  });

  /// Whether this is an edit (vs. create) operation.
  bool get isEditing => existingActivity != null;

  @override
  List<Object?> get props => [
        startTime,
        endTime,
        date,
        selectedPictogramId,
        selectedPictogram,
        existingActivity,
        pictogramMode,
        pictogramName,
        generatePrompt,
        // PlatformFile uses identity (reference) comparison — acceptable
        selectedImageFile,
        selectedSoundFile,
        generateSound,
        isCreatingPictogram,
        searchResults,
        isSearching,
      ];
}

/// Form is ready for user input.
final class ActivityFormReady extends ActivityFormState {
  /// Optional error message from a previous failed operation.
  final String? error;

  const ActivityFormReady({
    this.error,
    super.startTime,
    super.endTime,
    required super.date,
    super.selectedPictogramId,
    super.selectedPictogram,
    super.existingActivity,
    super.pictogramMode,
    super.pictogramName,
    super.generatePrompt,
    super.selectedImageFile,
    super.selectedSoundFile,
    super.generateSound,
    super.isCreatingPictogram,
    super.searchResults,
    super.isSearching,
  });

  @override
  List<Object?> get props => [error, ...super.props];
}

/// The activity is being saved (create or update).
final class ActivityFormSaving extends ActivityFormState {
  const ActivityFormSaving({
    super.startTime,
    super.endTime,
    required super.date,
    super.selectedPictogramId,
    super.selectedPictogram,
    super.existingActivity,
    super.pictogramMode,
    super.pictogramName,
    super.generatePrompt,
    super.selectedImageFile,
    super.selectedSoundFile,
    super.generateSound,
    super.isCreatingPictogram,
    super.searchResults,
    super.isSearching,
  });
}

/// The activity was saved successfully.
final class ActivityFormSaved extends ActivityFormState {
  const ActivityFormSaved({
    super.startTime,
    super.endTime,
    required super.date,
    super.selectedPictogramId,
    super.selectedPictogram,
    super.existingActivity,
    super.pictogramMode,
    super.pictogramName,
    super.generatePrompt,
    super.selectedImageFile,
    super.selectedSoundFile,
    super.generateSound,
    super.isCreatingPictogram,
    super.searchResults,
    super.isSearching,
  });
}
