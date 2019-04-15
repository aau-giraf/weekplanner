import 'package:api_client/api/api.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

class ChooseCitizenBloc extends BlocBase {
  ///
  ChooseCitizenBloc(this._api) {
    _api.user.me().flatMap((GirafUserModel user) {
      return _api.user.getCitizens(user.id);
    }).listen((List<UsernameModel> citizens) {
      _citizens.add(citizens);
    });
  }

  final Api _api;
  AuthBloc authBloc;
  final BehaviorSubject<List<UsernameModel>> _citizens =
  BehaviorSubject<List<UsernameModel>>.seeded(<UsernameModel>[]);

  Stream<List<UsernameModel>> get citizen => _citizens.stream;

  @override
  void dispose() {
    _citizens.close();
  }
}
