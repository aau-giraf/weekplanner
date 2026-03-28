import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/models/pictogram.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

/// Mode for how the user is adding a pictogram.
enum PictogramMode { search, upload, generate }

// ── Sub-state: Activity timing & identity ──────────────────

/// Core activity form fields: when it happens and which activity is edited.
final class ActivityFormData with EquatableMixin {
  /// Start time of the activity.
  final TimeValue startTime;

  /// End time of the activity.
  final TimeValue endTime;

  /// Date of the activity.
  final DateTime date;

  /// The activity being edited, or null for new activities.
  final Activity? existingActivity;

  const ActivityFormData({
    this.startTime = const (hour: 8, minute: 0),
    this.endTime = const (hour: 9, minute: 0),
    required this.date,
    this.existingActivity,
  });

  /// Whether this is an edit (vs. create) operation.
  bool get isEditing => existingActivity != null;

  ActivityFormData copyWith({
    TimeValue? startTime,
    TimeValue? endTime,
    DateTime? date,
    Activity? existingActivity,
    bool clearExistingActivity = false,
  }) {
    return ActivityFormData(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      date: date ?? this.date,
      existingActivity: clearExistingActivity
          ? null
          : (existingActivity ?? this.existingActivity),
    );
  }

  @override
  List<Object?> get props => [startTime, endTime, date, existingActivity];
}

// ── Sub-state: Pictogram selection ─────────────────────────

/// Tracks the currently selected pictogram.
final class PictogramSelection with EquatableMixin {
  /// ID of the selected pictogram, if any.
  final int? id;

  /// Full pictogram object, if selected.
  final Pictogram? pictogram;

  const PictogramSelection({this.id, this.pictogram});

  PictogramSelection copyWith({
    int? id,
    Pictogram? pictogram,
    bool clearSelection = false,
  }) {
    if (clearSelection) return const PictogramSelection();
    return PictogramSelection(
      id: id ?? this.id,
      pictogram: pictogram ?? this.pictogram,
    );
  }

  @override
  List<Object?> get props => [id, pictogram];
}

// ── Sub-state: Pictogram creation (upload / generate) ──────

/// Form state for creating a new pictogram via upload or AI generation.
final class PictogramCreation with EquatableMixin {
  /// Current pictogram selection mode.
  final PictogramMode mode;

  /// Name for a new pictogram being created.
  final String name;

  /// AI generation prompt for a new pictogram.
  final String generatePrompt;

  /// Selected image file for upload mode.
  final PlatformFile? imageFile;

  /// Selected sound file for upload mode.
  final PlatformFile? soundFile;

  /// Whether to auto-generate sound for new pictograms.
  final bool generateSound;

  /// Whether a pictogram creation operation is in progress.
  final bool isCreating;

  const PictogramCreation({
    this.mode = PictogramMode.search,
    this.name = '',
    this.generatePrompt = '',
    this.imageFile,
    this.soundFile,
    this.generateSound = true,
    this.isCreating = false,
  });

  PictogramCreation copyWith({
    PictogramMode? mode,
    String? name,
    String? generatePrompt,
    PlatformFile? imageFile,
    PlatformFile? soundFile,
    bool? generateSound,
    bool? isCreating,
    bool clearImageFile = false,
    bool clearSoundFile = false,
  }) {
    return PictogramCreation(
      mode: mode ?? this.mode,
      name: name ?? this.name,
      generatePrompt: generatePrompt ?? this.generatePrompt,
      imageFile: clearImageFile ? null : (imageFile ?? this.imageFile),
      soundFile: clearSoundFile ? null : (soundFile ?? this.soundFile),
      generateSound: generateSound ?? this.generateSound,
      isCreating: isCreating ?? this.isCreating,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        name,
        generatePrompt,
        // PlatformFile lacks value equality; identity comparison means
        // Equatable treats a new copyWith as changed even with the same
        // underlying file data — this is the desired conservative behavior.
        imageFile,
        soundFile,
        generateSound,
        isCreating,
      ];
}

// ── Sub-state: Pictogram search ────────────────────────────

/// Search results and loading state for the pictogram search tab.
final class PictogramSearch with EquatableMixin {
  /// Current pictogram search results.
  final List<Pictogram> results;

  /// Whether a pictogram search is in progress.
  final bool isSearching;

  const PictogramSearch({
    this.results = const [],
    this.isSearching = false,
  });

  PictogramSearch copyWith({
    List<Pictogram>? results,
    bool? isSearching,
  }) {
    return PictogramSearch(
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [results, isSearching];
}

// ── Composed state hierarchy ───────────────────────────────

/// State managed by [ActivityFormCubit].
sealed class ActivityFormState extends Equatable {
  /// Core activity form data (timing, date, identity).
  final ActivityFormData form;

  /// Currently selected pictogram.
  final PictogramSelection selection;

  /// Pictogram creation form state (upload/generate).
  final PictogramCreation creation;

  /// Pictogram search state.
  final PictogramSearch search;

  const ActivityFormState({
    required this.form,
    this.selection = const PictogramSelection(),
    this.creation = const PictogramCreation(),
    this.search = const PictogramSearch(),
  });

  /// Whether this is an edit (vs. create) operation.
  bool get isEditing => form.isEditing;

  @override
  List<Object?> get props => [form, selection, creation, search];
}

/// Form is ready for user input.
final class ActivityFormReady extends ActivityFormState {
  /// Optional error message from a previous failed operation.
  final String? error;

  const ActivityFormReady({
    this.error,
    required super.form,
    super.selection,
    super.creation,
    super.search,
  });

  @override
  List<Object?> get props => [error, ...super.props];
}

/// The activity is being saved (create or update).
final class ActivityFormSaving extends ActivityFormState {
  const ActivityFormSaving({
    required super.form,
    super.selection,
    super.creation,
    super.search,
  });
}

/// The activity was saved successfully.
final class ActivityFormSaved extends ActivityFormState {
  const ActivityFormSaved({
    required super.form,
    super.selection,
    super.creation,
    super.search,
  });
}
