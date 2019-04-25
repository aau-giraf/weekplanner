import 'dart:async';
import 'package:api_client/api/api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

/// New-Weekplan Business Logic Component.
class NewWeekplanBloc extends BlocBase {
  /// Constructor for [NewWeekplanBloc].
  /// The bloc contains sinks to handle when different inputs are entered and
  /// streams to tell if the inputs are valid.
  /// The bloc is also able to save the newly created weekplan.
  /// 
  /// It is important that the bloc is initialized before use!
  /// This is done with the method [initialize].
  NewWeekplanBloc(this._api);

  final Api _api;
  UsernameModel _user;

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

  /// Gives information about whether all inputs are valid.
  Observable<bool> get allInputsAreValidStream =>
      Observable.combineLatest4<bool, bool, bool, PictogramModel, bool>(
              validTitleStream,
              validYearStream,
              validWeekNumberStream,
              thumbnailStream,
              _isAllInputValid)
          .asBroadcastStream();

  /// Resets the bloc if it already contains information from the last time it
  /// was used. Switches user to the one provided.
  /// This method should always be called before using the bloc.
  void initialize(UsernameModel user) {
    if (_user != null) {
      resetBloc();
    }
    _user = user;
  }

  /// Saves the entered information to the database.
  Observable<WeekModel> saveWeekplan() {
    if (_user == null) {
      return null;
    }

    final String _title = _titleController.value;
    final int _year = int.parse(_yearController.value);
    final int _weekNumber = int.parse(_weekNumberController.value);
    final PictogramModel _thumbnail = _thumbnailController.value;

    final WeekModel _weekModel = WeekModel(
        thumbnail: _thumbnail,
        name: _title,
        weekYear: _year,
        weekNumber: _weekNumber,
        days: <WeekdayModel>[
          WeekdayModel(day: Weekday.Monday, activities: <ActivityModel>[]),
          WeekdayModel(day: Weekday.Tuesday, activities: <ActivityModel>[]),
          WeekdayModel(day: Weekday.Wednesday, activities: <ActivityModel>[]),
          WeekdayModel(day: Weekday.Thursday, activities: <ActivityModel>[]),
          WeekdayModel(day: Weekday.Friday, activities: <ActivityModel>[]),
          WeekdayModel(day: Weekday.Saturday, activities: <ActivityModel>[]),
          WeekdayModel(day: Weekday.Sunday, activities: <ActivityModel>[])
        ]);

    return _api.week.update(
        _user.id, _weekModel.weekYear, _weekModel.weekNumber, _weekModel);
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

  bool _isAllInputValid(
      bool title, bool year, bool weekNumber, PictogramModel thumbnail) {
    return title == true &&
        year == true &&
        weekNumber == true &&
        thumbnail != null;
  }

  final StreamTransformer<String, bool> _titleValidation =
      StreamTransformer<String, bool>.fromHandlers(
          handleData: (String input, EventSink<bool> sink) {
    if (input == null) {
      sink.add(null);
    } else {
      sink.add(input.isNotEmpty);
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
