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

/// Weekplanner API
class Api {
  /// To access account endpoints
  AccountApi account;

  /// To access department endpoints
  DepartmentApi department;

  /// To access pictogram endpoints
  PictogramApi pictogram;

  /// To access week endpoints
  WeekApi week;

  /// To access status endpoints
  StatusApi status;

  /// To access weekTemplate endpoints
  WeekTemplateApi weekTemplate;

  /// To access user endpoints
  UserApi user;

  String host;
  Api(this.host) {
    Persistence persist = PersistenceClient();
    account = AccountApi(HttpClient(host + "/v1", persist), persist);
    status = StatusApi(HttpClient(host + "/v1/Status", persist));
    department = DepartmentApi(HttpClient(host + "/v1/Department", persist));
    week = WeekApi(HttpClient(host + "/v1/User", persist));
    pictogram = PictogramApi(HttpClient(host + "/v1/Pictogram", persist));
    weekTemplate =
        WeekTemplateApi(HttpClient(host + "/v1/WeekTemplate", persist));
    user = UserApi(HttpClient(host + "/v1/User", persist));
  }

  /// Destroy the API
  void dispose() {}
}
