import 'dart:async';
import 'dart:io';
import 'package:api_client/api/api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/bloc_base.dart';

import 'blocs_api_exeptions.dart';

/// Bloc to obtain all citizens assigned to a guarding
class ChooseCitizenBloc extends BlocBase {
  /// Default Constructor
  ChooseCitizenBloc(this._api) {
    updateBloc();
  }

  /// The stream holding the citizens
  Stream<List<DisplayNameModel>> get citizen => _citizens.stream;

  /// Update the block with current users
  void updateBloc(){
    try{
      _api.user.me().flatMap((GirafUserModel user) {

        return _api.user.getCitizens(user.id);

      }).listen((List<DisplayNameModel> citizens) {
        _citizens.add(citizens);
      });
    } on SocketException{throw BlocsApiExeptions('Sock');}
    on HttpException{throw BlocsApiExeptions('Http');}
    on TimeoutException{throw BlocsApiExeptions('Time');}
    on FormatException{throw BlocsApiExeptions('Form');}
    on Exception catch(exeption)
    {throw BlocsApiExeptions('spec', '', exeption);}

  }

  final Api _api;
  final rx_dart.BehaviorSubject<List<DisplayNameModel>> _citizens =
  rx_dart.BehaviorSubject<List<DisplayNameModel>>.seeded(<DisplayNameModel>[]);

  @override
  void dispose() {
    _citizens.close();
  }
}
