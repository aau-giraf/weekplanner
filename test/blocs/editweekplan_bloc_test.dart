import 'package:api_client/api/api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/edit_weekplan_bloc.dart';

class MockWeekApi extends Mock implements WeekApi {}

void main() {
  EditWeekplanBloc bloc;
  Api api;
  MockWeekApi weekApi;
  final UsernameModel mockUser =
      UsernameModel(name: 'test', id: 'test', role: 'test');
  final WeekModel weekModel = WeekModel(weekNumber: 8, weekYear: 2020);
  final WeekNameModel weekNameModel =
      WeekNameModel(name: 'name', weekNumber: 8, weekYear: 2020);
  final List<WeekNameModel> weekNameModelList = <WeekNameModel>[];

  void setupApiCalls() {
    weekNameModelList.add(weekNameModel);

    when(weekApi.getNames('test')).thenAnswer(
        (_) => BehaviorSubject<List<WeekNameModel>>.seeded(weekNameModelList));

    when(weekApi
        .get('test', weekNameModel.weekYear, weekNameModel.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel));
  }

  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    api.week = weekApi;
    bloc = EditWeekplanBloc(api);
    bloc.initializeEditBloc(mockUser, weekModel);

    setupApiCalls();
  });
}