import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

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

  final rx_dart.BehaviorSubject<File> _file = rx_dart.BehaviorSubject<File>();
  /// Publishes the image file, while it is not null
  Stream<File> get file => _file.stream.where((File f) => f != null);
  /// Publishes if the input fields are filled
  Stream<bool> get isInputValid => _isInputValid.stream;

  final rx_dart.BehaviorSubject<bool> _isInputValid =
  rx_dart.BehaviorSubject<bool>.seeded(false);

  /// Handles when the entered display name is changed.
  Sink<String> get onDisplayNameChange => displayNameController.sink;
  /// Handles when the entered username is changed.
  Sink<String> get onUsernameChange => usernameController.sink;
  /// Handles when the entered password is changed.
  Sink<String> get onPasswordChange => passwordController.sink;
  /// Handles when the entered password verification is changed.
  Sink<String> get onPasswordVerifyChange => passwordVerifyController.sink;

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
      rx_dart.Rx.combineLatest2<String, String, bool>
        (passwordController.hasValue ? passwordController : ''
          , passwordVerifyController,
              (String a, String b) => a == b);


  /// Updates the current user(guardian)
  /// Necessary to call in case another user logs in without terminating the app
  void initialize() {
    resetBloc();
    _api.user.me().listen((GirafUserModel user) {
      _user = user;
    });
  }

  /// pushes an imagePicker screen, then sets the pictogram image,
  /// to the selected image from the gallery
  void takePictureWithCamera() {
    ImagePicker.pickImage(source: ImageSource.camera).then((File f) {
      if (f != null) {
        _publishImage(f);
        _checkInput();
      }
    });
  }

  /// pushes an imagePicker screen, then sets the profile picture image,
  /// to the selected image from the gallery
  void chooseImageFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((File f) {
      if (f != null) {
        _publishImage(f);
        _checkInput();
      }
    });
  }

  void _publishImage(File file) {
    _file.add(file);
  }

  /// Checks if the input fields are filled out
  void _checkInput() {
    if (_file.value != null) {
      _isInputValid.add(true);
    } else {
      _isInputValid.add(false);
    }
  }

  Uint8List _encodePng(File file) {
    return file != null
      ? encodePng(copyResize(decodeImage(file.readAsBytesSync()),
          width: 512)) // 512 bytes chosen as a reasonable input size.
      : null;
    }

  /// Method called with information about the new citizen.
  Stream<GirafUserModel> createCitizen() {
    return _api.account.register(
        usernameController.value,
        passwordController.value,
        displayNameController.value,
        _encodePng(_file.value),
        departmentId: _user.department,
        role: Role.Citizen,
    );
  }

  /// Method called with information about the trustee attached to the citizen.
  Stream<GirafUserModel> createTrustee() {
    return _api.account.register(
        usernameController.value,
        passwordController.value,
        displayNameController.value,
        _encodePng(_file.value),
        departmentId: _user.department,
        role: Role.Trustee
    );
  }

  /// Method called with information about the guardian attached to the citizen.
  Stream<GirafUserModel> createGuardian() {
    return _api.account.register(
        usernameController.value,
        passwordController.value,
        displayNameController.value,
         _encodePng(_file.value),
        departmentId: _user.department,
        role: Role.Guardian
    );
  }

  /// Gives information about whether all inputs are valid.
  Stream<bool> get allInputsAreValidStream =>
      rx_dart.Rx.combineLatest4<bool, bool, bool, bool, bool>(
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
          //Regular Expression to check if the username contains
          //only all letters, numbers, underscore and/or hyphen.
          sink.add(input.contains(RegExp(r'^[A-ZÆØÅ0-9_-]*$',
            caseSensitive : false)));
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
    _file.add(null);
  }

  @override
  void dispose() {
    displayNameController.close();
    usernameController.close();
    passwordController.close();
    passwordVerifyController.close();
    _file.close();
    _isInputValid.close();
  }
}