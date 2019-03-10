import 'package:weekplanner/providers/api/account_api.dart';
import 'package:weekplanner/providers/api/department_api.dart';
import 'package:weekplanner/providers/api/http.dart';
import 'package:weekplanner/providers/api/pictogram_api.dart';
import 'package:weekplanner/providers/persistence.dart';

class Api {
  AccountApi account;
  DepartmentApi department;
  PictogramApi pictogram;

  String baseUrl;

  Api(this.baseUrl) {
    Persistence persist = Persistence();
    account = AccountApi(Http(baseUrl + "/v1/Account", persist), persist);
    department = DepartmentApi(Http(baseUrl + "/v1/Department", persist));
    pictogram = PictogramApi(Http(baseUrl + "/v1/Pictogram", persist), persist);
  }

  void dispose() {
    account.dispose();
  }
}
