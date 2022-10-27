import 'dart:async';
import 'package:api_client/api/api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/bloc_base.dart';

/// Bloc to obtain all citizens assigned to a guarding
class ChooseCitizenBloc extends BlocBase {
  /// Default Constructor
  ChooseCitizenBloc(this._api) {
    updateBloc();
    GetCurrentUser();
  }

  /// The stream holding the citizens
  Stream<List<DisplayNameModel>> get citizen => _citizens.stream;

  /// Update the block with current users
  void updateBloc() {
    _api.user.me().flatMap((GirafUserModel user) {
      return _api.user.getCitizens(user.id);
    }).listen((List<DisplayNameModel> citizens) {
      _citizens.add(citizens);
    });
  }

  final Api _api;
  final rx_dart.BehaviorSubject<List<DisplayNameModel>> _citizens =
      rx_dart.BehaviorSubject<List<DisplayNameModel>>.seeded(
          <DisplayNameModel>[]);

  @override
  void dispose() {
    _citizens.close();
  }

  GirafUserModel GetCurrentUser() {
    GirafUserModel _user;
    _api.user.get("61863405-b7e7-4c40-9c53-713ad191d094").listen((user) {
      print("FetchUser found: " + user.displayName);
      _user = user;
      //return DisplayNameModel.fromGirafUser(user);
    }).onDone(() {
      print("Done fetching user " + _user.displayName);
      return _user;
    });
  }
}
