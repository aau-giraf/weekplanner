import 'package:api_client/api/api.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

/// Bloc to obtain all citizens assigned to a guarding
class ChooseCitizenBloc extends BlocBase {
  /// Default Constructor
  ChooseCitizenBloc(this._api) {
    _api.user.me().flatMap((GirafUserModel user) {
      return _api.user.getCitizens(user.id);
    }).listen((List<UsernameModel> citizens) {
      _citizens.add(citizens);
    });
  }

  /// The stream holding the citizens
  Stream<List<UsernameModel>> get citizen => _citizens.stream;

  final Api _api;
  final BehaviorSubject<List<UsernameModel>> _citizens =
      BehaviorSubject<List<UsernameModel>>.seeded(<UsernameModel>[]);

  @override
  void dispose() {
    _citizens.close();
  }
}
