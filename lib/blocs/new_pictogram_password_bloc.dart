import 'dart:async';
import 'package:api_client/api/api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/bloc_base.dart';

/// Used to create a new pictogram password for a citizen
class NewPictogramPasswordBloc extends BlocBase {
  /// Constructor
  NewPictogramPasswordBloc(this._api);

  final Api _api;
  GirafUserModel _user;

  /// The username for the citizen that one is creating a password for.
  String userName;

  /// The display name for the citizen that one is creating a password for.
  String displayName;

  ///
  final rx_dart.BehaviorSubject<String> pictogramPasswordController =
      rx_dart.BehaviorSubject<String>();

  /// To be called whenever somethings needs to be added to the controller
  Sink<String> get onPictogramPasswordChanged =>
      pictogramPasswordController.sink;

  Stream<bool> get validPictogramPasswordStream =>
      pictogramPasswordController.stream.transform(_passwordValidation);

  final StreamTransformer<String, bool> _passwordValidation =
      StreamTransformer<String, bool>.fromHandlers(
          handleData: (String input, EventSink<bool> sink) {
    if (input == null) {
      sink.add(false);
    } else {
      sink.add(true);
    }
  });

  /// Creates a user with the given information.
  Stream<GirafUserModel> createCitizen() {
    return _api.account.register(
        userName, pictogramPasswordController.value, displayName,
        departmentId: _user.department, role: Role.Citizen);
  }

  /// Initializes the bloc.
  void initialize(String _userName, String _displayName) {
    reset();
    userName = _userName;
    displayName = _displayName;
    _api.user.me().listen((GirafUserModel user) {
      _user = user;
    });
  }

  /// Resets the blocs variables, so that no information is stored.
  void reset() {
    userName = null;
    displayName = null;
    pictogramPasswordController.add(null);
    _user = null;
  }

  @override
  void dispose() {
    pictogramPasswordController.close();
  }
}
