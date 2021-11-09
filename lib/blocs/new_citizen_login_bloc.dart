import 'package:api_client/api/api.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

///Bloc for the creation of a citizens password
class NewCitizenLoginBloc extends BlocBase{
    NewCitizenLoginBloc(this._api);

    final Api _api;

  @override
  void dispose() {

  }

}