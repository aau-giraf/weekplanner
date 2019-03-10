import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/models/week_name_model.dart';
import 'package:weekplanner/providers/http/http.dart';

class WeekApi {
  final Http _http;

  WeekApi(this._http);

  Observable<WeekNameModel> getNames(String id) {
    return _http.get("/$id/week").map((Response res) {
      return WeekNameModel.fromJson(res.json["data"]);
    });
  }

  Observable<WeekModel> get(String id, int year, int weekNumber) {
    return _http.get("/$id/week/$year/$weekNumber").map((Response res) {
      return WeekModel.fromJson(res.json["data"]);
    });
  }

  Observable<WeekModel> update(
      String id, int year, int weekNumber, WeekModel week) {
    return _http
        .put("/$id/week/$year/$weekNumber", week.toJson())
        .map((Response res) {
      return WeekModel.fromJson(res.json["data"]);
    });
  }

  Observable<bool> delete(String id, int year, int weekNumber) {
    return _http.delete("/$id/week/$year/$weekNumber").map((Response res) {
      return res.json["success"];
    });
  }
}
