import 'dart:async';

import 'package:api_client/api/api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

///This bloc is used by a guardian to instantiate a new citizen.
class NewCitizenBloc extends BlocBase {

  ///Constructor for the bloc
  NewCitizenBloc(this._api);

  final Api _api;
  GirafUserModel _user;

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
  /// Handles when the entered username is changed.
  Sink<String> get onUsernameChange => usernameController.sink;
  /// Handles when the entered password is changed.
  Sink<String> get onPasswordChange => passwordController.sink;
  /// Handles when the entered password verification is changed.
  Sink<String> get onPasswordVerifyChange => passwordVerifyController.sink;

  /// Validation stream for display name
  Observable<bool> get validDisplayNameStream =>
      displayNameController.stream.transform(_displayNameValidation);
  /// Validation stream for username
  Observable<bool> get validUsernameStream =>
      usernameController.stream.transform(_usernameValidation);
  /// Validation stream for password
  Observable<bool> get validPasswordStream =>
      passwordController.stream.transform(_passwordValidation);
  /// Validation stream for password validation
  Observable<bool> get validPasswordVerificationStream =>
      Observable.combineLatest2<String, String, bool>
        (passwordController, passwordVerifyController,
              (String a, String b) => a == b);

  /// Updates the current user(guardian)
  /// Necessary to call in case another user logs in without terminating the app
  void initialize() {
    _api.user.me().listen((GirafUserModel user) {
      _user = user;
    });
  }

  /// Method called with information about the new citizen.
  Observable<GirafUserModel> createCitizen() {
    return _api.account.register(
        usernameController.value,
        passwordController.value,
        displayName: displayNameController.value,
        departmentId: _user.department,
        role: Role.Citizen
    );
  }
  /// Gives information about whether all inputs are valid.
  Observable<bool> get allInputsAreValidStream =>
      Observable.combineLatest4<bool, bool, bool, bool, bool>(
          validDisplayNameStream,
          validUsernameStream,
          validPasswordStream,
          validPasswordVerificationStream,
          (bool a, bool b, bool c, bool d) => a && b && c && d)
          .asBroadcastStream();

  /// Stream for display name validation
  final StreamTransformer<String, bool> _displayNameValidation =
  StreamTransformer<String, bool>.fromHandlers(
      handleData: (String input, EventSink<bool> sink) {
        if (input == null || input.isEmpty) {
          sink.add(false);
        } else {
          sink.add(input.trim().isNotEmpty);
        }
      });

  /// Stream for username validation
  final StreamTransformer<String, bool> _usernameValidation =
  StreamTransformer<String, bool>.fromHandlers(
      handleData: (String input, EventSink<bool> sink) {
        if (input == null || input.isEmpty) {
          sink.add(false);
        } else {
          sink.add(!input.contains(' '));
        }
      });

  /// Stream for password validation
  final StreamTransformer<String, bool> _passwordValidation =
  StreamTransformer<String, bool>.fromHandlers(
      handleData: (String input, EventSink<bool> sink) {
        if (input == null || input.isEmpty) {
          sink.add(false);
        } else {
          sink.add(!input.contains(' '));
        }
      });

  ///Resets bloc so no information is stored
  void resetBloc() {
    displayNameController.sink.add(null);
    usernameController.sink.add(null);
    passwordController.sink.add(null);
    passwordVerifyController.sink.add(null);
    _user = null;
  }

  @override
  void dispose() {
    displayNameController.close();
    usernameController.close();
    passwordController.close();
    passwordVerifyController.close();
  }

}