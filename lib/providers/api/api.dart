import 'package:weekplanner/providers/api/account_api.dart';
import 'package:weekplanner/providers/api/department_api.dart';
import 'package:weekplanner/providers/api/pictogram_api.dart';
import 'package:weekplanner/providers/api/status_api.dart';
import 'package:weekplanner/providers/api/week_template_api.dart';
import 'package:weekplanner/providers/http/http_client.dart';
import 'package:weekplanner/providers/peristence/persistence.dart';
import 'package:weekplanner/providers/peristence/persistence_client.dart';

class Api {
  AccountApi account;
  DepartmentApi department;
  PictogramApi pictogram;
  StatusApi status;
  WeekTemplateApi weekTemplate;

  String baseUrl;

  Api(this.baseUrl) {
    Persistence persist = PersistenceClient();
    account = AccountApi(HttpClient(baseUrl + "/v1/", persist), persist);
    status = StatusApi(HttpClient(baseUrl + "/v1/Status", persist));
    department =
        DepartmentApi(HttpClient(baseUrl + "/v1/Department", persist), persist);
    pictogram =
        PictogramApi(HttpClient(baseUrl + "/v1/Pictogram", persist), persist);

    weekTemplate =
        WeekTemplateApi(HttpClient(baseUrl + "/v1/WeekTemplate", persist));
  }

  void dispose() {
    account.dispose();
  }
}
