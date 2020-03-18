import 'package:api_client/api/api.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

///This bloc is used by a guardian to instantiate a new citizen.
class NewCitizenBloc extends BlocBase {

  ///Constructor for the bloc
  NewCitizenBloc(this._api);

  final Api _api;

  ///Method called with information about the new citizen.
  ///[displayName] is the name of the citizen.
  ///[username] and [password] is the login information.
  ///Returns true if success and false otherwise.
  bool createCitizen(String displayName, String username, String password, ) {
    //TODO: Implement method to create a citizen

    return true;
  }

  @override
  void dispose() {
    // TODO: Implement dispose
  }

}