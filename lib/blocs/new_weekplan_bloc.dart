import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/providers/api/api.dart';

/// New-Weekplan Business Logic Component.
class NewWeekplanBloc extends BlocBase {
  /// New-Weekplan Business Logic Component.
  ///
  /// Gives the ability to create a new weekplan.
  NewWeekplanBloc(this._api);

  final Api _api;
  GirafUserModel _user;

  final BehaviorSubject<String> _titleController = BehaviorSubject<String>();
  final BehaviorSubject<String> _yearController = BehaviorSubject<String>();
  final BehaviorSubject<String> _weekNumberController =
      BehaviorSubject<String>();
  final BehaviorSubject<PictogramModel> _thumbnailController =
      BehaviorSubject<PictogramModel>();

  /// Handles when the entered title is changed.
  Sink<String> get onTitleChanged => _titleController.sink;

  /// Handles when the entered year is changed.
  Sink<String> get onYearChanged => _yearController.sink;

  /// Handles when the entered week number is changed.
  Sink<String> get onWeekNumberChanged => _weekNumberController.sink;

  /// Handles when the thumbnail is changed.
  Sink<PictogramModel> get onThumbnailChanged => _thumbnailController.sink;

  /// Gives information about whether the entered title is valid.
  /// Values can be true (valid), false (invalid) and null (initial value).
  Observable<bool> get validTitleStream =>
      _titleController.stream.transform(_titleValidation);

  /// Gives information about whether the entered year is valid.
  /// Values can be true (valid), false (invalid) and null (initial value).
  Observable<bool> get validYearStream =>
      _yearController.stream.transform(_yearValidation);

  /// Gives information about whether the entered week number is valid.
  /// Values can be true (valid), false (invalid) and null (initial value).
  Observable<bool> get validWeekNumberStream =>
      _weekNumberController.stream.transform(_weekNumberValidation);

  /// Streams the chosen thumbnail.
  Observable<PictogramModel> get thumbnailStream => _thumbnailController.stream;

  /// Gives information about whether all input fields are valid.
  Observable<bool> get validInputStream =>
      Observable.combineLatest3<bool, bool, bool, bool>(validTitleStream,
              validYearStream, validWeekNumberStream, _isAllInputValid)
          .asBroadcastStream();

  /// Resets the bloc if it already contains information from the last time it 
  /// was used. Should always be called before using the bloc.
  void initialize(GirafUserModel user) {
    if (_user != null) {
      resetBloc();
    }
    _user = user;
  }

  /// Saves the entered information to the database.
  void saveWeekplan() {
    if (_user != null) {
      final String _title = _titleController.value;
      final int _year = int.parse(_yearController.value);
      final int _weekNumber = int.parse(_weekNumberController.value);
      final PictogramModel _thumbnail = _thumbnailController.value;

      final WeekModel _weekModel = WeekModel(
          thumbnail: _thumbnail,
          name: _title,
          weekYear: _year,
          weekNumber: _weekNumber);
      _api.week.update(
          _user.id, _weekModel.weekYear, _weekModel.weekNumber, _weekModel);
    }
  }

  /// Resets the bloc to its default values.
  /// The bloc should be reset after each use.
  void resetBloc() {
    _user = null;
    _titleController.sink.add(null);
    _yearController.sink.add(null);
    _weekNumberController.sink.add(null);
    _thumbnailController.sink.add(null);
  }

  bool _isAllInputValid(bool title, bool year, bool weekNumber) {
    return title == true && year == true && weekNumber == true;
  }

  final StreamTransformer<String, bool> _titleValidation =
      StreamTransformer<String, bool>.fromHandlers(
          handleData: (String input, EventSink<bool> sink) {
    if (input == null) {
      sink.add(null);
    } else {
      sink.add(input.isNotEmpty && input.length <= 32);
    }
  });

  final StreamTransformer<String, bool> _yearValidation =
      StreamTransformer<String, bool>.fromHandlers(
          handleData: (String input, EventSink<bool> sink) {
    if (input == null) {
      sink.add(null);
    } else {
      final int year = int.tryParse(input);
      sink.add(year != null && year >= 1000 && year <= 9999);
    }
  });

  final StreamTransformer<String, bool> _weekNumberValidation =
      StreamTransformer<String, bool>.fromHandlers(
          handleData: (String input, EventSink<bool> sink) {
    if (input == null) {
      sink.add(null);
    } else {
      final int weekNumber = int.tryParse(input);
      sink.add(weekNumber != null && weekNumber >= 1 && weekNumber <= 53);
    }
  });

  @override
  void dispose() {
    _titleController.close();
    _yearController.close();
    _weekNumberController.close();
    _thumbnailController.close();
  }
}
