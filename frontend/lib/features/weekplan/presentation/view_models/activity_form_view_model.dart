import 'package:flutter/material.dart';
import 'package:weekplanner/features/weekplan/data/repositories/activity_repository.dart';
import 'package:weekplanner/features/weekplan/data/repositories/pictogram_repository.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/models/pictogram.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

enum PictogramMode { search, upload, generate }

class ActivityFormViewModel extends ChangeNotifier {
  final ActivityRepository _activityRepository;
  final PictogramRepository _pictogramRepository;

  ActivityFormViewModel({
    required ActivityRepository activityRepository,
    required PictogramRepository pictogramRepository,
    this.existingActivity,
    required this.subjectId,
    required this.isCitizen,
    required DateTime initialDate,
  })  : _activityRepository = activityRepository,
        _pictogramRepository = pictogramRepository {
    if (existingActivity != null) {
      _startTime = TimeOfDay(
        hour: int.parse(existingActivity!.startTime.split(':')[0]),
        minute: int.parse(existingActivity!.startTime.split(':')[1]),
      );
      _endTime = TimeOfDay(
        hour: int.parse(existingActivity!.endTime.split(':')[0]),
        minute: int.parse(existingActivity!.endTime.split(':')[1]),
      );
      _selectedPictogramId = existingActivity!.pictogramId;
      _date = DateTime.parse(existingActivity!.date);
    } else {
      _date = initialDate;
    }
  }

  final Activity? existingActivity;
  final int subjectId;
  final bool isCitizen;

  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 9, minute: 0);
  int? _selectedPictogramId;
  Pictogram? _selectedPictogram;
  late DateTime _date;
  bool _isLoading = false;
  String? _error;

  // Pictogram creation state
  PictogramMode _pictogramMode = PictogramMode.search;
  String _pictogramName = '';
  String _generatePrompt = '';
  String? _selectedImagePath;
  String? _selectedSoundPath;
  bool _generateSound = true;
  bool _isCreatingPictogram = false;

  TimeOfDay get startTime => _startTime;
  TimeOfDay get endTime => _endTime;
  int? get selectedPictogramId => _selectedPictogramId;
  Pictogram? get selectedPictogram => _selectedPictogram;
  DateTime get date => _date;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEditing => existingActivity != null;

  List<Pictogram> get searchResults => _pictogramRepository.pictograms;
  bool get isSearching => _pictogramRepository.isLoading;

  PictogramMode get pictogramMode => _pictogramMode;
  String get pictogramName => _pictogramName;
  String get generatePrompt => _generatePrompt;
  String? get selectedImagePath => _selectedImagePath;
  String? get selectedSoundPath => _selectedSoundPath;
  bool get generateSound => _generateSound;
  bool get isCreatingPictogram => _isCreatingPictogram;

  void setPictogramMode(PictogramMode mode) {
    _pictogramMode = mode;
    notifyListeners();
  }

  void setPictogramName(String name) {
    _pictogramName = name;
  }

  void setGeneratePrompt(String prompt) {
    _generatePrompt = prompt;
  }

  void setSelectedImagePath(String? path) {
    _selectedImagePath = path;
    notifyListeners();
  }

  void setSelectedSoundPath(String? path) {
    _selectedSoundPath = path;
    notifyListeners();
  }

  void setGenerateSound(bool value) {
    _generateSound = value;
    notifyListeners();
  }

  void setStartTime(TimeOfDay time) {
    _startTime = time;
    notifyListeners();
  }

  void setEndTime(TimeOfDay time) {
    _endTime = time;
    notifyListeners();
  }

  void selectPictogram(Pictogram pictogram) {
    _selectedPictogramId = pictogram.id;
    _selectedPictogram = pictogram;
    notifyListeners();
  }

  Future<void> searchPictograms(String query) =>
      _pictogramRepository.searchPictograms(query);

  /// Upload a local image as a new pictogram and select it.
  Future<bool> uploadPictogramFromFile() async {
    if (_selectedImagePath == null || _pictogramName.isEmpty) {
      _error = 'Angiv navn og vælg et billede';
      notifyListeners();
      return false;
    }

    _isCreatingPictogram = true;
    _error = null;
    notifyListeners();

    try {
      final pictogram = await _pictogramRepository.uploadPictogram(
        name: _pictogramName,
        imagePath: _selectedImagePath!,
        soundPath: _selectedSoundPath,
        generateSound: _generateSound,
      );
      selectPictogram(pictogram);
      _isCreatingPictogram = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isCreatingPictogram = false;
      _error = 'Kunne ikke uploade piktogram';
      notifyListeners();
      return false;
    }
  }

  /// Create a pictogram via AI generation and select it.
  Future<bool> generatePictogram() async {
    final prompt = _generatePrompt.isNotEmpty ? _generatePrompt : _pictogramName;
    if (prompt.isEmpty) {
      _error = 'Angiv et navn eller en beskrivelse';
      notifyListeners();
      return false;
    }

    _isCreatingPictogram = true;
    _error = null;
    notifyListeners();

    try {
      final pictogram = await _pictogramRepository.createPictogram(
        name: _pictogramName.isNotEmpty ? _pictogramName : prompt,
        generateImage: true,
        generateSound: _generateSound,
      );
      selectPictogram(pictogram);
      _isCreatingPictogram = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isCreatingPictogram = false;
      _error = 'Kunne ikke generere piktogram';
      notifyListeners();
      return false;
    }
  }

  String? validate() {
    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;
    if (endMinutes <= startMinutes) {
      return 'Sluttid skal være efter starttid';
    }
    return null;
  }

  Future<bool> save() async {
    final validationError = validate();
    if (validationError != null) {
      _error = validationError;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = {
        'date': GirafDateUtils.formatQueryDate(_date),
        'startTime':
            '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}:00',
        'endTime':
            '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}:00',
        if (_selectedPictogramId != null) 'pictogramId': _selectedPictogramId,
      };

      if (isEditing) {
        await _activityRepository.updateActivity(existingActivity!.activityId, data);
      } else {
        await _activityRepository.createActivity(
          id: subjectId,
          isCitizen: isCitizen,
          data: data,
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = isEditing
          ? 'Kunne ikke opdatere aktivitet'
          : 'Kunne ikke oprette aktivitet';
      notifyListeners();
      return false;
    }
  }
}
