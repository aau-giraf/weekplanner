import 'dart:async';

import 'package:api_client/api/api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/bloc_base.dart';

///This bloc is used by a guardian to instantiate a new citizen.
class NewCitizenBloc extends BlocBase {
  ///Constructor for the bloc
  NewCitizenBloc(this._api);

  final Api _api;
  GirafUserModel _user;

  /// This field controls the display name input field
  final rx_dart.BehaviorSubject<String> displayNameController =
      rx_dart.BehaviorSubject<String>();

  /// This field controls the username input field
  final rx_dart.BehaviorSubject<String> usernameController =
      rx_dart.BehaviorSubject<String>();

  /// This field controls the password input field
  final rx_dart.BehaviorSubject<String> passwordController =
      rx_dart.BehaviorSubject<String>();

  /// This field controls the password verification input field
  final rx_dart.BehaviorSubject<String> passwordVerifyController =
      rx_dart.BehaviorSubject<String>();

  /// This field controls the switch for pictogram password
  final rx_dart.BehaviorSubject<bool> usePictogramPasswordController =
      rx_dart.BehaviorSubject<bool>();

  /// Handles when the entered display name is changed.
  Sink<String> get onDisplayNameChange => displayNameController.sink;

  /// Handles when the entered username is changed.
  Sink<String> get onUsernameChange => usernameController.sink;

  /// Handles when the entered password is changed.
  Sink<String> get onPasswordChange => passwordController.sink;

  /// Handles when the entered password verification is changed.
  Sink<String> get onPasswordVerifyChange => passwordVerifyController.sink;

  /// Handles when the switch for pictogram password is changed.
  Sink<bool> get onUsePictogramPasswordChange =>
      usePictogramPasswordController.sink;

  /// Validation stream for display name
  Stream<bool> get validDisplayNameStream =>
      displayNameController.stream.transform(_displayNameValidation);

  /// Validation stream for username
  Stream<bool> get validUsernameStream =>
      usernameController.stream.transform(_usernameValidation);

  /// Validation stream for password
  Stream<bool> get validPasswordStream =>
      passwordController.stream.transform(_passwordValidation);

  /// Validation stream for password validation
  Stream<bool> get validPasswordVerificationStream =>
      rx_dart.Rx.combineLatest2<String, String, bool>(
          passwordController.hasValue ? passwordController : '',
          passwordVerifyController,
          (String a, String b) => a == b);

  /// Validation stream for determining if the user wants to use Pictogram PW
  Stream<bool> get usePictogramPasswordStream =>
      usePictogramPasswordController.stream.transform(_usePictogramPassword);

  /// Updates the current user(guardian)
  /// Necessary to call in case another user logs in without terminating the app
  void initialize() {
    resetBloc();
    _api.user.me().listen((GirafUserModel user) {
      _user = user;
    });
  }

  /// Method called with information about the new citizen.
  Stream<GirafUserModel> createCitizen() {
    return _api.account.register(usernameController.value,
        passwordController.value, displayNameController.value,
        departmentId: _user.department, role: Role.Citizen);
  }

  /// Method called with information about the trustee attached to the citizen.
  Stream<GirafUserModel> createTrustee() {
    return _api.account.register(usernameController.value,
        passwordController.value, displayNameController.value,
        departmentId: _user.department, role: Role.Trustee);
  }

  /// Method called with information about the guardian attached to the citizen.
  Stream<GirafUserModel> createGuardian() {
    return _api.account.register(usernameController.value,
        passwordController.value, displayNameController.value,
        departmentId: _user.department, role: Role.Guardian);
  }

  /// Gives information about whether all inputs are valid,
  /// if the user does not want to use a pictogram password.
  Stream<bool> get allInputsAreValidStream =>
      rx_dart.Rx.combineLatest5<bool, bool, bool, bool, bool, bool>(
          validDisplayNameStream,
          validUsernameStream,
          validPasswordStream,
          validPasswordVerificationStream,
          usePictogramPasswordStream,
          (bool a, bool b, bool c, bool d, bool e) =>
              a && b && c && d && !e).asBroadcastStream();

  /// Gives information about whether all inputs are valid,
  /// if the user wants to use a pictogram password.
  Stream<bool> get validUsePictogramStream =>
      rx_dart.Rx.combineLatest3<bool, bool, bool, bool>(
          validDisplayNameStream,
          validUsernameStream,
          usePictogramPasswordStream,
          (bool a, bool b, bool c) => a && b && c).asBroadcastStream();

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
      //Regular Expression to check if the username contains
      //only all letters, numbers, underscore and/or hyphen.
      sink.add(
          input.contains(RegExp(r'^[A-ZÆØÅ0-9_-]*$', caseSensitive: false)));
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

  /// Stream for pictogram PW
  final StreamTransformer<bool, bool> _usePictogramPassword =
      StreamTransformer<bool, bool>.fromHandlers(
          handleData: (bool input, EventSink<bool> sink) {
    sink.add(input);
  });

  ///Resets bloc so no information is stored
  void resetBloc() {
    displayNameController.sink.add(null);
    usernameController.sink.add(null);
    passwordController.sink.add(null);
    passwordVerifyController.sink.add(null);
    usePictogramPasswordController.sink.add(false);
    _user = null;
  }

  @override
  void dispose() {
    displayNameController.close();
    usernameController.close();
    passwordController.close();
    passwordVerifyController.close();
    usePictogramPasswordController.close();
  }
}
