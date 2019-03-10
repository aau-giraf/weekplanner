import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/response_model.dart';
import 'package:weekplanner/models/role_enum.dart';
import 'package:weekplanner/providers/api/http.dart';
import 'package:weekplanner/providers/persistence.dart';

class AccountApi {
  Observable<bool> get loggedIn => _loggedIn.stream;
  final _loggedIn = new BehaviorSubject<bool>();

  final Http _http;
  final Persistence persist;

  AccountApi(this._http, this.persist);

  Observable<bool> login(String username, String password) {
    return _http.post("/login", {
      "username": username,
      "password": password,
    }).flatMap((Response res) {
      ResponseModel<String> response =
          ResponseModel.fromJson(res.json, res.json["data"]);

      return Observable.fromFuture(Future(() async {
        await persist.setToken(response.data);
        return response;
      }));
    }).flatMap((ResponseModel<String> res) {
      _loggedIn.add(res.success);
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