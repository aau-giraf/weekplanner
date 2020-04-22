import 'package:api_client/api/api.dart';
import 'package:api_client/models/username_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';

/// Bloc to copy a weekplan to other users
class CopyWeekplanBloc extends ChooseCitizenBloc {
  /// Default constructor
  CopyWeekplanBloc(Api api) : super(api);

  /// The stream that emits the marked activities
  Stream<List<UsernameModel>> get markedUserModels => _markedUserModels.stream;

  final BehaviorSubject<List<UsernameModel>> _markedUserModels =
  BehaviorSubject<List<UsernameModel>>.seeded(<UsernameModel>[]);

  /// Copies weekplan to all selected citizens
  void copyToMarkedCitizens(){

  }

  /// Adds a new marked week model to the stream
  void toggleMarkedWeekModel(UsernameModel user) {
    final List<UsernameModel> localMarkedWeekModels = _markedUserModels.value;
    if (localMarkedWeekModels.contains(user)) {
      localMarkedWeekModels.remove(user);
    } else {
      localMarkedWeekModels.add(user);
    }

    _markedUserModels.add(localMarkedWeekModels);
  }

  /// Clears marked week models
  void clearMarkedWeekModels() {
    _markedUserModels.add(<UsernameModel>[]);
  }

}