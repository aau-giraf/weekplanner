import 'package:weekplanner/providers/api/account.dart';
import 'package:weekplanner/providers/api/department.dart';
import 'package:weekplanner/providers/api/http.dart';

class Api {
  Account account;
  Department department;

  String baseUrl;

  Api(this.baseUrl) {
    account = Account(Http(baseUrl + "/v1/Account"));
    department = Department(Http(baseUrl + "/v1/Department"));
  }

  void dispose() {
    account.dispose();
  }
}
