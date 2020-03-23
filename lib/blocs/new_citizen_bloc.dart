import 'package:api_client/api/api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

///This bloc is used by a guardian to instantiate a new citizen.
class NewCitizenBloc extends BlocBase {

  ///Constructor for the bloc
  NewCitizenBloc(this._api);

  final Api _api;

   /// This field controls the display name input field
  final BehaviorSubject<String> displayNameController =
      BehaviorSubject<String>();
   /// This field controls the username input field
  final BehaviorSubject<String> usernameController =
      BehaviorSubject<String>();
   /// This field controls the password input field
  final BehaviorSubject<String> passwordController =
      BehaviorSubject<String>();
   /// This field controls the password verification input field
  final BehaviorSubject<String> passwordVerifyController =
      BehaviorSubject<String>();

  /// Handles when the entered display name is changed.
  Sink<String> get onDisplayNameChange => displayNameController.sink;
  /// Handles when the entered display name is changed.
  Sink<String> get onUsernameChange => usernameController.sink;
  /// Handles when the entered display name is changed.
  Sink<String> get onPasswordChange => passwordController.sink;
  /// Handles when the entered display name is changed.
  Sink<String> get onPasswordVerifyChange => passwordVerifyController.sink;

  ///Method called with information about the new citizen.
  ///[displayName] is the name of the citizen.
  ///[username] and [password] is the login information.
  ///Returns true if success and false otherwise.
  bool createCitizen(String displayName, String username, String password, ) {
    //TODO: Implement method to create a citizen
    print(displayName + " : " + username + " : " + password);
    return true;

  }

  //TODO: Create method for validation of input
  void checkValid() {

  }

  @override
  void dispose() {
    // TODO: Implement dispose
  }

}