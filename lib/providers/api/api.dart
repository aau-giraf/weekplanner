import 'package:weekplanner/providers/api/account_api.dart';
import 'package:weekplanner/providers/api/department_api.dart';
import 'package:weekplanner/providers/api/http.dart';
import 'package:weekplanner/providers/persistence.dart';

class Api {
  AccountApi account;
  DepartmentApi department;

  String baseUrl;

  Api(this.baseUrl) {
    Persistence persist = Persistence();
    account = AccountApi(Http(baseUrl + "/v1/Account", persist), persist);
    department = DepartmentApi(Http(baseUrl + "/v1/Department", persist));
  }

  void dispose() {
    account.dispose();
  }
}
