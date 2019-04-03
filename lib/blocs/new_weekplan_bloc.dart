import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/providers/api/api.dart';

/// New-Weekplan Business Logic Component
class NewWeekplanBloc extends BlocBase {
  /// New-Weekplan Business Logic Component
  ///
  /// Gives the ability to create a new empty weekplan
  NewWeekplanBloc(this._api) {
    validInputStream.listen(print);
  }

  final Api _api;
  GirafUserModel _user;

  final BehaviorSubject<String> _titleController = BehaviorSubject<String>();
  final BehaviorSubject<String> _yearController = BehaviorSubject<String>();
  final BehaviorSubject<String> _weekNumberController =
      BehaviorSubject<String>();
  final BehaviorSubject<PictogramModel> _thumbnailController =
      BehaviorSubject<PictogramModel>();

  /// Handles when the entered title is changed
  Sink<String> get onTitleChanged => _titleController.sink;

  /// Handles when the entered year is changed
  Sink<String> get onYearChanged => _yearController.sink;

  /// Handles when the entered week number is changed
  Sink<String> get onWeekNumberChanged => _weekNumberController.sink;

  /// Handles when the thumbnail is changed
  Sink<PictogramModel> get onThumbnailChanged => _thumbnailController.sink;

  /// Gives information about whether the entered title is valid
  Observable<bool> get validTitleStream =>
      _titleController.stream.transform(_titleValidation);

  /// Gives information about whether the entered year is valid
  Observable<bool> get validYearStream =>
      _yearController.stream.transform(_yearValidation);

  /// Gives information about whether the entered week number is valid
  Observable<bool> get validWeekNumberStream =>
      _weekNumberController.stream.transform(_weekNumberValidation);

  /// Streams the chosen thumbnail
  Observable<PictogramModel> get thumbnailStream => _thumbnailController.stream;

  /// Gives information about whether all input fields are valid
  Observable<bool> get validInputStream =>
      Observable.combineLatest3<bool, bool, bool, bool>(
          validTitleStream,
          validYearStream,
          validWeekNumberStream,
          (bool s1, bool s2, bool s3) => s1 && s2 && s3).asBroadcastStream();

  /// We need an id for the current citizen
  void load(GirafUserModel user) {
    _user = user;
  }

  /// Saves the entered information to the database
  void save() {
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
    resetBloc();
  }

  /// Resets the bloc to its default values
  /// The bloc should be reset after leaving the NewWeekplanScreen
  void resetBloc() {
    _user = null;
    _titleController.sink.add(null);
    _yearController.sink.add(null);
    _weekNumberController.sink.add(null);
    _thumbnailController.sink.add(null);
  }

  final StreamTransformer<String, bool> _titleValidation =
      StreamTransformer<String, bool>.fromHandlers(
          handleData: (String input, EventSink<bool> sink) {
    sink.add(input != null && input.isNotEmpty && input.length <= 32);
  });

  final StreamTransformer<String, bool> _yearValidation =
      StreamTransformer<String, bool>.fromHandlers(
          handleData: (String input, EventSink<bool> sink) {
    if (input != null) {
      final int year = int.tryParse(input);
      sink.add(year != null && input.length == 4);
    } else {
      sink.add(false);
    }
  });

  final StreamTransformer<String, bool> _weekNumberValidation =
      StreamTransformer<String, bool>.fromHandlers(
          handleData: (String input, EventSink<bool> sink) {
    if (input != null) {
      final int weekNumber = int.tryParse(input);
      sink.add(weekNumber != null && weekNumber >= 1 && weekNumber <= 53);
    } else {
      sink.add(false);
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
