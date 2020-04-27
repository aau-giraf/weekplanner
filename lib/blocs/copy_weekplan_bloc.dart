import 'dart:async';
import 'package:api_client/api/api.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_model.dart';
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
  void copyWeekplan(WeekModel weekModel, UsernameModel currentUser,
      bool forThisCitizen) async {

    List<UsernameModel> users = <UsernameModel>[];
    if (forThisCitizen) {
      users.add(currentUser);
    } else {
      users = _markedUserModels.value;
    }

    for (UsernameModel user in users) {
      _api.week
          .update(user.id, weekModel.weekYear, weekModel.weekNumber, weekModel)
          .take(1)
          .listen((WeekModel weekModel) {});
    }
  }

  /// Returns a list of all users which already have a weekplan in the same week
  Future<List<UsernameModel>> getConflictingUsers(
      List<UsernameModel> users, WeekModel weekModel) async {
    List<UsernameModel> conflictingUsers = <UsernameModel>[];
    for (UsernameModel user in users) {
      if (await isConflictingUser(user, weekModel)) {
        conflictingUsers.add(user);
      }
    }
    return conflictingUsers;
  }

  /// Checks if any user has a conflicting weekplan
  Future<int> numberOfConflictingUsers(WeekModel weekModel,
      UsernameModel currentUser, bool forThisCitizen) async {
    List<UsernameModel> users =
        forThisCitizen ? <UsernameModel>[currentUser] : _markedUserModels.value;
    List<UsernameModel> conflictingUsers =
        await getConflictingUsers(users, weekModel);
    return conflictingUsers.length;
  }

  /// Compares a single Citizen's Weekplans with the copied weekplan
  Future<bool> isConflictingUser(
      UsernameModel user, WeekModel weekModel) async {
    bool daysAreEmpty = true;
    WeekModel response = await _api.week
        .get(user.id, weekModel.weekYear, weekModel.weekNumber)
        .first;

    for (WeekdayModel weekDay in response.days) {
      daysAreEmpty = daysAreEmpty && weekDay.activities.isEmpty;
    }

    return !daysAreEmpty;
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
