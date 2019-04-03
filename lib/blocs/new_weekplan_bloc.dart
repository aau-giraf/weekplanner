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
  String _title;
  int _year;
  int _weekNumber;

  /// Gives information about whether the entered title is valid
  Observable<bool> get validTitleStream => _validTitleController.stream;
  final BehaviorSubject<bool> _validTitleController = BehaviorSubject<bool>();

  /// Gives information about whether the entered year is valid
  Observable<bool> get validYearStream => _validYearController.stream;
  final BehaviorSubject<bool> _validYearController = BehaviorSubject<bool>();

  /// Gives information about whether the entered week number is valid
  Observable<bool> get validWeekNumberStream =>
      _validWeekNumberController.stream;
  final BehaviorSubject<bool> _validWeekNumberController =
      BehaviorSubject<bool>();

  /// Gives information about whether all input fields are valid
  Observable<bool> get validInputStream =>
      Observable.combineLatest3<bool, bool, bool, bool>(
          validTitleStream, validYearStream, validWeekNumberStream,
          (bool s1, bool s2, bool s3) {
        return s1 && s2 && s3;
      }).asBroadcastStream();

  /// The thumbnail pictogram of the new weekplan
  PictogramModel pictogram;

  /// Should be called when the text in the title input field is changed
  /// Validates the title and adds whether it is valid to _validTitleController
  void onTitleChanged(String title) {
    _validTitleController.sink.add(_isValidTitle(title));
  }

  /// Should be called when the text in the year input field is changed
  /// Validates the year and adds whether it is valid to _validYearController
  void onYearChanged(String year) {
    _validYearController.sink.add(_isValidYear(year));
  }

  /// Should be called when the text in the weekNumber input field is changed
  /// Validates the week number and adds whether it is valid to
  /// _validWeekNumberController
  void onWeekNumberChanged(String weekNumber) {
    _validWeekNumberController.sink.add(_isValidWeekNumber(weekNumber));
  }

  /// We need an id for the current citizen
  void load(GirafUserModel user) {
    _user = user;
  }

  /// Saves the entered information to the database
  void save() {
    final WeekModel _weekModel = WeekModel(
        thumbnail: pictogram,
        name: _title,
        weekYear: _year,
        weekNumber: _weekNumber);
    _saveToDatabase(_user.id, _year, _weekNumber, _weekModel);
  }

  bool _isValidTitle(String input) {
    if (input != null && input.isNotEmpty && input.length <= 32) {
      _title = input;
      return true;
    }
    return false;
  }

  bool _isValidYear(String input) {
    final int year = int.tryParse(input);
    if (year != null && year >= 2000 && year < 3000) {
      _year = year;
      return true;
    }
    return false;
  }

  bool _isValidWeekNumber(String input) {
    final int weekNumber = int.tryParse(input);
    if (weekNumber != null && weekNumber >= 1 && weekNumber <= 53) {
      _weekNumber = weekNumber;
      return true;
    }
    return false;
  }

  void _saveToDatabase(
      String id, int year, int weekNumber, WeekModel weekModel) {
    _api.week.update(id, year, weekNumber, weekModel);
  }

  @override
  void dispose() {
    _validTitleController.close();
    _validYearController.close();
    _validWeekNumberController.close();
  }
}
