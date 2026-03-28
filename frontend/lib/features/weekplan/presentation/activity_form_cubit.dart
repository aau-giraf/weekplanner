import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';

import 'package:weekplanner/core/errors/activity_failure.dart';
import 'package:weekplanner/features/weekplan/domain/repositories/activity_repository.dart';
import 'package:weekplanner/features/weekplan/domain/repositories/pictogram_repository.dart';
import 'package:weekplanner/features/weekplan/domain/activity_form_state.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/models/pictogram.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

final _log = Logger('ActivityFormCubit');

/// Manages state for the activity create/edit form.
///
/// Handles form field updates, pictogram search with debounce,
/// pictogram creation (upload + AI generation), and activity save.
class ActivityFormCubit extends Cubit<ActivityFormState> {
  final ActivityRepository _activityRepository;
  final PictogramRepository _pictogramRepository;
  final int subjectId;
  final bool isCitizen;
  final int? organizationId;

  Timer? _searchDebounce;

  ActivityFormCubit({
    required ActivityRepository activityRepository,
    required PictogramRepository pictogramRepository,
    required this.subjectId,
    required this.isCitizen,
    this.organizationId,
    Activity? existingActivity,
    required DateTime initialDate,
  })  : _activityRepository = activityRepository,
        _pictogramRepository = pictogramRepository,
        super(ActivityFormReady(
          form: ActivityFormData(
            date: existingActivity?.date ?? initialDate,
            startTime:
                existingActivity?.startTime ?? const (hour: 8, minute: 0),
            endTime: existingActivity?.endTime ?? const (hour: 9, minute: 0),
            existingActivity: existingActivity,
          ),
          selection: PictogramSelection(
            id: existingActivity?.pictogramId,
          ),
        ));

  // ── Form field setters ────────────────────────────────────

  void setStartTime(TimeValue time) {
    _emitReady(form: state.form.copyWith(startTime: time));
  }

  void setEndTime(TimeValue time) {
    _emitReady(form: state.form.copyWith(endTime: time));
  }

  void setPictogramMode(PictogramMode mode) {
    _emitReady(creation: state.creation.copyWith(mode: mode));
  }

  void setPictogramName(String name) {
    _emitReady(creation: state.creation.copyWith(name: name));
  }

  void setGeneratePrompt(String prompt) {
    _emitReady(creation: state.creation.copyWith(generatePrompt: prompt));
  }

  void setSelectedImageFile(PlatformFile? file) {
    if (file == null) {
      _emitReady(creation: state.creation.copyWith(clearImageFile: true));
    } else {
      _emitReady(creation: state.creation.copyWith(imageFile: file));
    }
  }

  void setSelectedSoundFile(PlatformFile? file) {
    if (file == null) {
      _emitReady(creation: state.creation.copyWith(clearSoundFile: true));
    } else {
      _emitReady(creation: state.creation.copyWith(soundFile: file));
    }
  }

  void setGenerateSound(bool value) {
    _emitReady(creation: state.creation.copyWith(generateSound: value));
  }

  void selectPictogram(Pictogram pictogram) {
    _emitReady(
      selection: PictogramSelection(id: pictogram.id, pictogram: pictogram),
    );
  }

  // ── Pictogram search ─────────────────────────────────────

  /// Debounced search — call on every keystroke.
  void onSearchQueryChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      searchPictograms(query);
    });
  }

  /// Execute a pictogram search immediately.
  Future<void> searchPictograms(String query) async {
    _emitReady(search: state.search.copyWith(isSearching: true));

    final result = await _pictogramRepository.searchPictograms(query);
    switch (result) {
      case Left(:final value):
        _log.warning('Pictogram search failed: ${value.message}');
        _emitReady(search: state.search.copyWith(isSearching: false));
      case Right(:final value):
        _emitReady(
          search: PictogramSearch(results: value, isSearching: false),
        );
    }
  }

  // ── Pictogram creation ───────────────────────────────────

  /// Upload a local image as a new pictogram and select it.
  Future<bool> uploadPictogramFromFile() async {
    if (state.creation.imageFile == null || state.creation.name.isEmpty) {
      _emitReady(error: 'Angiv navn og vælg et billede');
      return false;
    }

    _emitReady(creation: state.creation.copyWith(isCreating: true));

    final result = await _pictogramRepository.uploadPictogram(
      name: state.creation.name,
      imageFile: state.creation.imageFile!,
      soundFile: state.creation.soundFile,
      organizationId: organizationId,
      generateSound: state.creation.generateSound,
    );

    switch (result) {
      case Left(:final value):
        _emitReady(
          creation: state.creation.copyWith(isCreating: false),
          error: value.message,
        );
        return false;
      case Right(:final value):
        _emitReady(
          creation: state.creation.copyWith(isCreating: false),
          selection: PictogramSelection(id: value.id, pictogram: value),
        );
        return true;
    }
  }

  /// Create a pictogram via AI generation and select it.
  Future<bool> generatePictogram() async {
    final prompt = state.creation.generatePrompt.isNotEmpty
        ? state.creation.generatePrompt
        : state.creation.name;
    if (prompt.isEmpty) {
      _emitReady(error: 'Angiv et navn eller en beskrivelse');
      return false;
    }

    _emitReady(creation: state.creation.copyWith(isCreating: true));

    final result = await _pictogramRepository.createPictogram(
      name: prompt,
      organizationId: organizationId,
      generateImage: true,
      generateSound: state.creation.generateSound,
    );

    switch (result) {
      case Left(:final value):
        _emitReady(
          creation: state.creation.copyWith(isCreating: false),
          error: value.message,
        );
        return false;
      case Right(:final value):
        _emitReady(
          creation: state.creation.copyWith(isCreating: false),
          selection: PictogramSelection(id: value.id, pictogram: value),
        );
        return true;
    }
  }

  // ── Validation and save ──────────────────────────────────

  /// Validate the form and return an error message, or null if valid.
  String? validate() {
    final startMinutes =
        state.form.startTime.hour * 60 + state.form.startTime.minute;
    final endMinutes =
        state.form.endTime.hour * 60 + state.form.endTime.minute;
    if (endMinutes <= startMinutes) {
      return 'Sluttid skal være efter starttid';
    }
    return null;
  }

  /// Save the activity (create or update). Returns true on success.
  Future<bool> save() async {
    final validationError = validate();
    if (validationError != null) {
      _emitReady(error: validationError);
      return false;
    }

    final s = state;
    emit(ActivityFormSaving(
      form: s.form,
      selection: s.selection,
      creation: s.creation,
      search: s.search,
    ));

    final data = {
      'date': GirafDateUtils.formatQueryDate(s.form.date),
      'startTime': formatTimeValueForApi(s.form.startTime),
      'endTime': formatTimeValueForApi(s.form.endTime),
      if (s.selection.id != null) 'pictogramId': s.selection.id,
    };

    final Either<ActivityFailure, Activity> result;
    if (s.form.isEditing) {
      result = await _activityRepository.updateActivity(
          s.form.existingActivity!.activityId, data);
    } else {
      result = await _activityRepository.createActivity(
        id: subjectId,
        isCitizen: isCitizen,
        data: data,
      );
    }

    switch (result) {
      case Left(:final value):
        _emitReady(error: value.message);
        return false;
      case Right():
        emit(ActivityFormSaved(
          form: s.form,
          selection: s.selection,
          creation: s.creation,
          search: s.search,
        ));
        return true;
    }
  }

  // ── Helpers ──────────────────────────────────────────────

  /// Emit an [ActivityFormReady] state, carrying forward all sub-states
  /// from the current state unless explicitly overridden.
  void _emitReady({
    String? error,
    ActivityFormData? form,
    PictogramSelection? selection,
    PictogramCreation? creation,
    PictogramSearch? search,
  }) {
    emit(ActivityFormReady(
      error: error,
      form: form ?? state.form,
      selection: selection ?? state.selection,
      creation: creation ?? state.creation,
      search: search ?? state.search,
    ));
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
