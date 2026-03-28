import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/models/pictogram.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

/// Mode for how the user is adding a pictogram.
enum PictogramMode { search, upload, generate }

// ── Sub-state: Activity timing & identity ──────────────────

/// Core activity form fields: when it happens and which activity is edited.
class ActivityFormData with EquatableMixin {
  final TimeValue startTime;
  final TimeValue endTime;
  final DateTime date;
  final Activity? existingActivity;

  const ActivityFormData({
    this.startTime = const (hour: 8, minute: 0),
    this.endTime = const (hour: 9, minute: 0),
    required this.date,
    this.existingActivity,
  });

  bool get isEditing => existingActivity != null;

  ActivityFormData copyWith({
    TimeValue? startTime,
    TimeValue? endTime,
    DateTime? date,
    Activity? existingActivity,
  }) {
    return ActivityFormData(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      date: date ?? this.date,
      existingActivity: existingActivity ?? this.existingActivity,
    );
  }

  @override
  List<Object?> get props => [startTime, endTime, date, existingActivity];
}

// ── Sub-state: Pictogram selection ─────────────────────────

/// Tracks the currently selected pictogram.
class PictogramSelection with EquatableMixin {
  final int? id;
  final Pictogram? pictogram;

  const PictogramSelection({this.id, this.pictogram});

  PictogramSelection copyWith({int? id, Pictogram? pictogram}) {
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
class PictogramCreation with EquatableMixin {
  final PictogramMode mode;
  final String name;
  final String generatePrompt;
  final PlatformFile? imageFile;
  final PlatformFile? soundFile;
  final bool generateSound;
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
        // PlatformFile uses identity (reference) comparison — acceptable
        imageFile,
        soundFile,
        generateSound,
        isCreating,
      ];
}

// ── Sub-state: Pictogram search ────────────────────────────

/// Search results and loading state for the pictogram search tab.
class PictogramSearch with EquatableMixin {
  final List<Pictogram> results;
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
  final ActivityFormData form;
  final PictogramSelection selection;
  final PictogramCreation creation;
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
