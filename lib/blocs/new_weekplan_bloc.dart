import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/providers/api/api.dart';

class NewWeekplanBloc extends BlocBase {
  final Api _api;
  String _title;
  int _year;
  int _weekNumber;

  /// The thumbnail pictogram of the new weekplan
  PictogramModel gram;

  NewWeekplanBloc(this._api) { }

  void onTitleSubmitted(String title) {
    _isValidTitle(title);
  }

  void onYearSubmitted(String year) {
    _isValidYear(year);
  }

  void onWeekNumberSubmitted(String weekNumber) {
    _isValidWeekNumber(weekNumber);
  }

  /// Saves the entered information to the database
  void save() {
    final WeekModel _weekModel = WeekModel(
        thumbnail: gram,
        name: _title,
        weekYear: _year,
        weekNumber: _weekNumber);
    // _saveToDatabase(id, _year, _weekNumber, _weekModel);
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
    // _saveEventController.close();
  }
}
