import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/models/week_name_model.dart';
import 'package:weekplanner/providers/http/http.dart';

class WeekApi {
  final Http _http;

  WeekApi(this._http);

  /// Get week names from the user with the given ID
  ///
  /// [id] User ID
  Observable<List<WeekNameModel>> getNames(String id) {
    return _http.get("/$id/week").map((Response res) {
      return (res.json["data"] as List)
          .map((json) => WeekNameModel.fromJson(json))
          .toList();
    });
  }

  /// Gets the Week with the specified week number and year for the user with
  /// the given id.
  ///
  /// [id] User ID
  /// [year] Year the week is in
  /// [weekNumber] The week-number of the week
  Observable<WeekModel> get(String id, int year, int weekNumber) {
    return _http.get("/$id/week/$year/$weekNumber").map((Response res) {
      return WeekModel.fromJson(res.json["data"]);
    });
  }

  /// Updates the entire information of the week with the given year and week
  /// number.
  ///
  /// [id] User ID
  /// [year] Year the week is in
  /// [weekNumber] The week-number of the week
  Observable<WeekModel> update(
      String id, int year, int weekNumber, WeekModel week) {
    return _http
        .put("/$id/week/$year/$weekNumber", week.toJson())
        .map((Response res) {
      return WeekModel.fromJson(res.json["data"]);
    });
  }

  /// Deletes all information for the entire week with the given year and week
  /// number.
  ///
  /// [id] User ID
  /// [year] Year the week is in
  /// [weekNumber] The week-number of the week
  Observable<bool> delete(String id, int year, int weekNumber) {
    return _http.delete("/$id/week/$year/$weekNumber").map((Response res) {
      return res.json["success"];
    });
  }
}
