import 'package:weekplanner/providers/api/account_api.dart';
import 'package:weekplanner/providers/api/department_api.dart';
import 'package:weekplanner/providers/api/pictogram_api.dart';
import 'package:weekplanner/providers/api/user_api.dart';
import 'package:weekplanner/providers/api/week_api.dart';
import 'package:weekplanner/providers/api/status_api.dart';
import 'package:weekplanner/providers/api/week_template_api.dart';
import 'package:weekplanner/providers/http/http_client.dart';
import 'package:weekplanner/providers/persistence/persistence.dart';
import 'package:weekplanner/providers/persistence/persistence_client.dart';

class Api {
  AccountApi account;
  DepartmentApi department;
  PictogramApi pictogram;
  WeekApi week;
  StatusApi status;
  WeekTemplateApi weekTemplate;
  UserApi user;

  String serverUrl;
  int serverPort;
  String protocol;
  Api(this.protocol, this.serverUrl, this.serverPort) {
    String baseUrl =
        this.protocol + "://" + serverUrl + ":" + serverPort.toString();
    Persistence persist = PersistenceClient();
    account = AccountApi(HttpClient(baseUrl + "/v1", persist), persist);
    status = StatusApi(HttpClient(baseUrl + "/v1/Status", persist));
    department =
        DepartmentApi(HttpClient(baseUrl + "/v1/Department", persist), persist);
    week = WeekApi(HttpClient(baseUrl + "/v1/User", persist));
    pictogram = PictogramApi(HttpClient(baseUrl + "/v1/Pictogram", persist));
    weekTemplate =
        WeekTemplateApi(HttpClient(baseUrl + "/v1/WeekTemplate", persist));
    user = UserApi(HttpClient(baseUrl + "/v1/User", persist));
  }

  void dispose() {}
}
