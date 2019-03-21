import 'dart:async';

import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/providers/api/api.dart';

class NewWeekplanBloc extends BlocBase {
  StreamController<String> _saveEventController = StreamController<String>();
  Sink<String> get saveEventSink => _saveEventController.sink;

  final Api _api;
  String _title;
  int _year;
  int _weekNumber;

  PictogramModel gram =
      PictogramModel(id: 7, lastEdit: DateTime(1992), title: "test");

  NewWeekplanBloc(this._api) {
    _saveEventController.stream.listen((title) => _onSaveEvent(title));
  }

  void _onSaveEvent(String title, String year, String weekNumber,
      PictogramModel pictogramModel) {
    if (_isValidTitle(title) &&
        _isValidYear(year) &&
        _isValidWeekNumber(weekNumber)) {
      WeekModel _weekModel = WeekModel(
          thumbnail: pictogramModel,
          name: _title,
          weekYear: _year,
          weekNumber: _weekNumber);
      _saveToDatabase(id, _year, _weekNumber, _weekModel);
    }
  }

  bool _isValidTitle(String input) {
    if (input != null && input.length >= 1 && input.length <= 32) {
      _title = input;
      return true;
    }
    return false;
  }

  bool _isValidYear(String input) {
    int year = int.tryParse(input);
    if (year != null && year >= 2000 && year < 3000) {
      _year = year;
      return true;
    }
    return false;
  }

  bool _isValidWeekNumber(String input) {
    int weekNumber = int.tryParse(input);
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
    _saveEventController.close();
  }
}
