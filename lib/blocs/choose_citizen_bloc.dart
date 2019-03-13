import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/providers/api/api.dart';

class ChooseCitizenBloc extends BlocBase {

  Api _api;

  ChooseCitizenBloc(this._api);

  Stream<List<UsernameModel>> get citizen => _citizens.stream;

  BehaviorSubject<List<UsernameModel>> _citizens = BehaviorSubject();

  void load() {
    _api.user.me().flatMap((GirafUserModel user) {
      return _api.user.getCitizens(user.id);
    }).listen((List<UsernameModel> citizens) {
      _citizens.add(citizens);
    });
  }

  /*void choose(BuildContext context) {
    Navigator.pushNamed(context, "/weekplan");
  }*/

  @override
  void dispose() {
    _citizens.close();
  }
}
