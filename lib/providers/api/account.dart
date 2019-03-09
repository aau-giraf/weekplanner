import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/response_model.dart';
import 'package:weekplanner/models/role_enum.dart';
import 'package:weekplanner/providers/api/http.dart';

class Account {
  Observable<bool> get loggedIn => _loggedIn.stream;
  final _loggedIn = new BehaviorSubject<bool>();

  final Http _http;
  Account(this._http);

  Observable<bool> login(String username, String password) {
    return _http.post("/login", {
      "username": username,
      "password": password,
    }).flatMap((Response res) {
      ResponseModel<String> response =
          ResponseModel.fromJson(res.json, res.json["data"]);

      Http.token = response.data;
      _loggedIn.add(response.success);
      return _loggedIn;
    });
  }

  Observable<GirafUserModel> register(String username, String password,
      {String displayName, @required departmentId, @required Role role}) {
    Map<String, String> body = {
      "username": username,
      "password": password,
      "departmentId": departmentId,
      "role": role.toString(),
    };

    if (displayName != null) {
      body["displayName"] = displayName;
    }

    return _http.post("/register", body).map((Response res) {
      GirafUserModel user = GirafUserModel.fromJson(res.json["data"]);
      return user;
    });
  }

  Observable<bool> changePassword(String oldPassword, String newPassword) {
    return _http.put("/password", {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    }).map((Response res) {
      return res.json["success"];
    });
  }

  void logout() {
    _loggedIn.add(false);
  }

  void dispose() {
    _loggedIn.close();
  }
}
