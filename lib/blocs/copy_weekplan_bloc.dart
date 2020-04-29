import 'dart:async';
import 'package:api_client/api/api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';

/// Bloc to copy a weekplan to other users
class CopyWeekplanBloc extends ChooseCitizenBloc {
  /// Default constructor
  CopyWeekplanBloc(this._api) : super(_api);

  /// The stream that emits the marked activities
  Stream<List<DisplayNameModel>> get markedUserModels
      => _markedUserModels.stream;

  final BehaviorSubject<List<DisplayNameModel>> _markedUserModels =
      BehaviorSubject<List<DisplayNameModel>>.seeded(<DisplayNameModel>[]);
  final Api _api;

  /// Copies weekplan to all selected citizens
  // ignore: avoid_void_async
  void copyWeekplan(WeekModel weekModel, DisplayNameModel currentUser,
      bool forThisCitizen) async {

    List<DisplayNameModel> users = <DisplayNameModel>[];
    if (forThisCitizen) {
      users.add(currentUser);
    } else {
      users = _markedUserModels.value;
    }

    for (DisplayNameModel user in users) {
      _api.week
          .update(user.id, weekModel.weekYear, weekModel.weekNumber, weekModel)
          .take(1)
          .listen((WeekModel weekModel) {});
    }
  }

  /// Returns a list of all users which already have a weekplan in the same week
  Future<List<DisplayNameModel>> getConflictingUsers(
      List<DisplayNameModel> users, WeekModel weekModel) async {
    final List<DisplayNameModel> conflictingUsers = <DisplayNameModel>[];
    for (DisplayNameModel user in users) {
      if (await isConflictingUser(user, weekModel)) {
        conflictingUsers.add(user);
      }
    }
    return conflictingUsers;
  }

  /// Checks if any user has a conflicting weekplan
  Future<int> numberOfConflictingUsers(WeekModel weekModel,
      DisplayNameModel currentUser, bool forThisCitizen) async {
    final List<DisplayNameModel> users =
        forThisCitizen ? <DisplayNameModel>[currentUser]
            : _markedUserModels.value;
    final List<DisplayNameModel> conflictingUsers =
        await getConflictingUsers(users, weekModel);
    return conflictingUsers.length;
  }

  /// Compares a single Citizen's Weekplans with the copied weekplan
  Future<bool> isConflictingUser(
      DisplayNameModel user, WeekModel weekModel) async {
    bool daysAreEmpty = true;
    final WeekModel response = await _api.week
        .get(user.id, weekModel.weekYear, weekModel.weekNumber)
        .first;

    for (WeekdayModel weekDay in response.days) {
      daysAreEmpty = daysAreEmpty && weekDay.activities.isEmpty;
    }

    return !daysAreEmpty;
  }

  /// Adds a new marked week model to the stream
  void toggleMarkedUserModel(DisplayNameModel user) {
    final List<DisplayNameModel> localMarkedUserModels
        = _markedUserModels.value;
    if (localMarkedUserModels.contains(user)) {
      localMarkedUserModels.remove(user);
    } else {
      localMarkedUserModels.add(user);
    }

    _markedUserModels.add(localMarkedUserModels);
  }
}
