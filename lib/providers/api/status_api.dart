import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/providers/http/http.dart';

class StatusApi {
  final Http _http;

  StatusApi(this._http);

  /// End-point for checking if the API is running.
  Observable<bool> status() {
    return _http.get("/").map((Response res) => res.json["success"]);
  }

  /// End-point for checking connection to the database.
  Observable<bool> databaseStatus() {
    return _http.get("/database").map((Response res) => res.json["success"]);
  }

  /// End-point for getting git version info, i.e. branch and commit hash
  Observable<String> versionInfo() {
    return _http
        .get("/database")
        .map((Response res) => res.json["data"] as String);
  }
}
