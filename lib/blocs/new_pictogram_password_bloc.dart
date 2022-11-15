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

  /// Creates a user with the given information.
  Stream<GirafUserModel> createCitizen() {
    return _api.account.register(userName, "password", displayName,
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
