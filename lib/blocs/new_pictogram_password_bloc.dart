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

  void initialize(String _userName, String _displayName) {
    reset();
    userName = _userName;
    displayName = _displayName;
  }

  void reset() {
    userName = null;
    displayName = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
