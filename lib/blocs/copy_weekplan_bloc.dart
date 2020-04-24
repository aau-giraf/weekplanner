import 'package:api_client/api/api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:quiver/async.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';

/// Bloc to copy a weekplan to other users
class CopyWeekplanBloc extends ChooseCitizenBloc {
  /// Default constructor
  CopyWeekplanBloc(this._api) : super(_api);

  /// The stream that emits the marked activities
  Stream<List<UsernameModel>> get markedUserModels => _markedUserModels.stream;

  final BehaviorSubject<List<UsernameModel>> _markedUserModels =
      BehaviorSubject<List<UsernameModel>>.seeded(<UsernameModel>[]);
  final Api _api;

  /// Copies weekplan to all selected citizens
  void copyToMarkedCitizens(WeekModel weekModel, List<UsernameModel> users) {
    List<UsernameModel> conflictingUsers =
        getConflictingUsers(users, weekModel);
    for (UsernameModel user in users) {
      if (conflictingUsers.contains(user)) {
        users.remove(user);
      }
    }
  }

  /// Returns a list of all users which already have a weekplan in the same week
  List getConflictingUsers(List<UsernameModel> users, WeekModel weekModel) {
    List<UsernameModel> conflictingUsers = <UsernameModel>[];
    for (UsernameModel user in users) {
      if (checkCitizenWeekNumber(user, weekModel)) {
        conflictingUsers.add(user);
      }
    }
    return conflictingUsers;
  }

  /// Compares a single Citizen's Weekplans with the copied weekplan
  bool checkCitizenWeekNumber(UsernameModel user, WeekModel weekModel) {
    if (_api.week.get(user.id, weekModel.weekYear, weekModel.weekYear) !=
        null) {
      return true;
    }
    return false;
  }

  /// Adds a new marked week model to the stream
  void toggleMarkedUserModel(UsernameModel user) {
    final List<UsernameModel> localMarkedUserModels = _markedUserModels.value;
    if (localMarkedUserModels.contains(user)) {
      localMarkedUserModels.remove(user);
    } else {
      localMarkedUserModels.add(user);
    }

    _markedUserModels.add(localMarkedUserModels);
  }
}
