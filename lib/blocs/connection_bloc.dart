import 'package:api_client/api/api.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/widgets/no_connection_dialog.dart';

class ConnectionBloc extends BlocBase{
  ConnectionBloc(this._api);

  final Api _api;

  Future<void> checkConnection() async {
    _api.connectivity.check();

    _api.connectivity.stream.listen((dynamic event) async {
      if (event) {
        NoConnectionDialog();
        print(event);
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
  }
}