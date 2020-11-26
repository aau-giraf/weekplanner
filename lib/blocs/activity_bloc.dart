
import 'dart:async';
import 'dart:io';

import 'package:api_client/models/displayname_model.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/api/api.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';

import 'blocs_api_exeptions.dart';

/// Logic for activities
class ActivityBloc extends BlocBase {
  /// Default Constructor.
  /// Initializes values
  ActivityBloc(this._api);

  /// Stream for updated ActivityModel.
  Stream<ActivityModel> get activityModelStream => _activityModelStream.stream;

  /// rx_dart.BehaviorSubject for the updated ActivityModel.
  final rx_dart.BehaviorSubject<ActivityModel> _activityModelStream =
      rx_dart.BehaviorSubject<ActivityModel>();

  final Api _api;
  ActivityModel _activityModel;
  DisplayNameModel _user;

  /// Loads the ActivityModel and the GirafUser.
  void load(ActivityModel activityModel, DisplayNameModel user) {
    _activityModel = activityModel;
    _user = user;
    _activityModelStream.add(activityModel);
  }
  /// Return the current ActivityModel
  ActivityModel getActivity(){
    return _activityModel;
  }

  /// Mark the selected activity as complete. Toggle function, if activity is
  /// Completed, it will become Normal
  void completeActivity() {
    _activityModel.state = _activityModel.state == ActivityState.Completed
        ? ActivityState.Normal
        : ActivityState.Completed;
    update();
  }

  /// Mark the selected activity as cancelled.Toggle function, if activity is
  /// Canceled, it will become Normal
  void cancelActivity() {
    _activityModel.state = _activityModel.state == ActivityState.Canceled
        ? ActivityState.Normal
        : ActivityState.Canceled;
    update();
  }

  /// Update the Activity with the new state.
  void update() {
    try{
      _api.activity
          .update(_activityModel, _user.id)
          .listen((ActivityModel activityModel) {
        _activityModel = activityModel;
        _activityModelStream.add(activityModel);
      });
    } on SocketException{throw BlocsApiExeptions('Sock');}
    on HttpException{throw BlocsApiExeptions('Http');}
    on TimeoutException{throw BlocsApiExeptions('Time');}
    on FormatException{throw BlocsApiExeptions('Form');}
    on Exception catch(exeption)
    {throw BlocsApiExeptions('spec', '', exeption);}
  }

  @override
  void dispose() {
    _activityModelStream.close();
  }
}
