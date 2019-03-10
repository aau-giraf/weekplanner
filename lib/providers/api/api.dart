import 'package:weekplanner/providers/api/account_api.dart';
import 'package:weekplanner/providers/api/department_api.dart';
import 'package:weekplanner/providers/http/http_client.dart';
import 'package:weekplanner/providers/peristence/persistence.dart';
import 'package:weekplanner/providers/peristence/persistence_client.dart';

class Api {
  AccountApi account;
  DepartmentApi department;

  String baseUrl;

  Api(this.baseUrl) {
    Persistence persist = PersistenceClient();
    account = AccountApi(HttpClient(baseUrl + "/v1/", persist), persist);
    department =
        DepartmentApi(HttpClient(baseUrl + "/v1/Department", persist), persist);
  }

  void dispose() {
    account.dispose();
  }
}
