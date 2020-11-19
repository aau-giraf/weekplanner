
import 'dart:async';
import 'package:api_client/models/displayname_model.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/api/api.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/alternate_name_model.dart';

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
  AlternateNameModel _alternateName;

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
    _api.activity
        .update(_activityModel, _user.id)
        .listen((ActivityModel activityModel) {
      _activityModel = activityModel;
      _activityModelStream.add(activityModel);
    });
  }

  /// Set a new alternate Name
  void setAlternateName(String name){

    _alternateName = null;
    final Completer<void> completer = Completer<void>();
    final AlternateNameModel newAn = AlternateNameModel(name: name,
        citizen: _user.id, pictogram: _activityModel.pictograms.first.id);
    getAlternateName().whenComplete(() {
      if (_alternateName == null) {
        _api.alternateName.create(newAn).listen((AlternateNameModel an) {
          _alternateName = an;
          _activityModel.title = _alternateName.name;
          update();
          completer.complete();
        });
      }
      else {
        _api.alternateName.put(_alternateName.id, newAn).listen(
                (AlternateNameModel an) {
              _alternateName = an;
              _activityModel.title = _alternateName.name;
              update();
              completer.complete();
            });
      }
    });

    Future.wait([completer.future]);

  }
  /// Method to get alternate name from api
  Future<void> getAlternateName(){
    final Completer<AlternateNameModel> f = Completer<AlternateNameModel>();
    _api.alternateName.get(_user.id, _activityModel.pictograms.first.id)
        .listen((Object result) {
          _alternateName = result;
          f.complete();
        }).onError((Object error){
          _alternateName = null;
          f.complete();
    });
    return f.future;
  }
  ///Method to get the standard tile from the pictogram
  void getStandardTitle(){
    _activityModel.title = _activityModel.pictograms.first.title;
    update();
  }

  @override
  void dispose() {
    _activityModelStream.close();
  }
}
