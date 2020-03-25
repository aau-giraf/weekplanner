import 'package:api_client/api/api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:async_test/async_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/weekplan_selector_bloc.dart';

class MockWeekApi extends Mock implements WeekApi {}

void main() {
  WeekplansBloc bloc;
  Api api;
  MockWeekApi weekApi;

  final List<WeekNameModel> weekNameModelList = <WeekNameModel>[];
  final WeekNameModel weekNameModel1 =
      WeekNameModel(name: 'name', weekNumber: 8, weekYear: 2020);
  final WeekNameModel weekNameModel2 =
      WeekNameModel(name: 'name', weekNumber: 3, weekYear: 2021);
  final WeekNameModel weekNameModel3 =
      WeekNameModel(name: 'name', weekNumber: 28, weekYear: 2020);
  final WeekNameModel weekNameModel4 =
      WeekNameModel(name: 'name', weekNumber: 3, weekYear: 2020);
  final WeekNameModel weekNameModel5 =
      WeekNameModel(name: 'name', weekNumber: 50, weekYear: 2019);
  final List<WeekModel> weekModelList = <WeekModel>[];
  final WeekModel weekModel1 = WeekModel(weekNumber: 8, weekYear: 2020);
  final WeekModel weekModel2 = WeekModel(weekNumber: 3, weekYear: 2021);
  final WeekModel weekModel3 = WeekModel(weekNumber: 28, weekYear: 2020);
  final WeekModel weekModel4 = WeekModel(weekNumber: 3, weekYear: 2020);
  final WeekModel weekModel5 = WeekModel(weekNumber: 50, weekYear: 2019);
  final UsernameModel mockUser =
      UsernameModel(name: 'test', id: 'test', role: 'test');

  void setupApiCalls() {
    weekNameModelList.clear();
    weekModelList.clear();

    weekModelList.add(weekModel1);
    weekNameModelList.add(weekNameModel1);

    when(weekApi.getNames('test')).thenAnswer(
        (_) => BehaviorSubject<List<WeekNameModel>>.seeded(weekNameModelList));

    when(weekApi
        .get('test', weekNameModel1.weekYear, weekNameModel1.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel1));

    when(weekApi
        .get('test', weekNameModel2.weekYear, weekNameModel2.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel2));

    when(weekApi
        .get('test', weekNameModel3.weekYear, weekNameModel3.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel3));

    when(weekApi
        .get('test', weekNameModel4.weekYear, weekNameModel4.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel4));

    when(weekApi
        .get('test', weekNameModel5.weekYear, weekNameModel5.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel5));

    when(weekApi.delete(mockUser.id, any, any))
        .thenAnswer((_) => BehaviorSubject<bool>.seeded(true));
  }

  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    api.week = weekApi;
    bloc = WeekplansBloc(api);

    setupApiCalls();
  });

  test('Should be able to load weekplans for a user', async((DoneFn done) {
    bloc.weekNameModels.listen((List<WeekNameModel> response) {
      expect(response, isNotNull);
      expect(response, equals(weekNameModelList));
    });

    bloc.weekModels.listen((List<WeekModel> response) {
      expect(response, isNotNull);
      expect(response, equals(weekModelList));
      done();
    });

    bloc.load(UsernameModel(name: 'test', role: 'test', id: 'test'));
  }));

  test('Should dispose weekModels stream', async((DoneFn done) {
    bloc.weekModels.listen((_) {}, onDone: done);
    bloc.dispose();
  }));

  test('Should dispose weekNameModel1 stream', async((DoneFn done) {
    bloc.weekNameModels.listen((_) {}, onDone: done);
    bloc.dispose();
  }));

  test('Adds a weekmodel to a list of marked weekmodels', async((DoneFn done) {
    bloc.markedWeekModels
        .skip(1)
        .listen((List<WeekModel> markedWeekModelsList) {
      expect(markedWeekModelsList.length, 1);
      done();
    });

    // Add the ActivityModel to the list of marked weekmodels.
    bloc.toggleMarkedWeekModel(weekModel1);
  }));

  test('Removes a weekmodel from the list of marked weekmodels',
      async((DoneFn done) {
    // Add the weekmodel to list of marked weekmodels
    bloc.toggleMarkedWeekModel(weekModel1);
    expect(bloc.getNumberOfMarkedWeekModels(), 1);

    bloc.markedWeekModels
        .skip(1)
        .listen((List<WeekModel> markedWeekModelsList) {
      expect(markedWeekModelsList.length, 0);
      done();
    });

    // Remove the weekmodel from the list of marked weekmodels.
    bloc.toggleMarkedWeekModel(weekModel1);
  }));

  test('Clear the list of marked weekmodels', async((DoneFn done) {
    // Add the weekmodel to list of marked weekmodels
    bloc.toggleMarkedWeekModel(weekModel1);
    expect(bloc.getNumberOfMarkedWeekModels(), 1);

    bloc.markedWeekModels
        .skip(1)
        .listen((List<WeekModel> markedWeekModelsList) {
      expect(markedWeekModelsList.length, 0);
      done();
    });

    // Clears the list of marked weekmodels.
    bloc.clearMarkedWeekModels();
  }));

  test('Checks if a weekmodel is marked', async((DoneFn done) {
    bloc.toggleMarkedWeekModel(weekModel1);
    expect(bloc.getNumberOfMarkedWeekModels(), 1);

    expect(bloc.isWeekModelMarked(weekModel1), true);
    done();
  }));

  test('Returns false if a weekmodel is not marked', async((DoneFn done) {
    bloc.toggleMarkedWeekModel(weekModel1);
    expect(bloc.getNumberOfMarkedWeekModels(), 1);

    bloc.toggleMarkedWeekModel(weekModel1);
    expect(bloc.getNumberOfMarkedWeekModels(), 0);

    expect(bloc.isWeekModelMarked(weekModel1), false);
    done();
  }));

  test('Checks if the number of marked weekmodels matches',
      async((DoneFn done) {
    bloc.toggleMarkedWeekModel(weekModel1);
    expect(bloc.getNumberOfMarkedWeekModels(), 1);

    bloc.toggleMarkedWeekModel(WeekModel(name: 'testWeekModel'));
    expect(bloc.getNumberOfMarkedWeekModels(), 2);

    bloc.toggleMarkedWeekModel(weekModel1);
    expect(bloc.getNumberOfMarkedWeekModels(), 1);
    done();
  }));

  test('Checks if the marked weekmodels are deleted from the weekmodels',
      async((DoneFn done) {
    final List<WeekNameModel> weekNameModelList = <WeekNameModel>[
      weekNameModel1
    ];
    when(weekApi.get(
            mockUser.id, weekNameModel1.weekYear, weekNameModel1.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel1));

    when(weekApi.getNames(mockUser.id)).thenAnswer(
        (_) => BehaviorSubject<List<WeekNameModel>>.seeded(weekNameModelList));

    bloc.load(mockUser);
    bloc.toggleMarkedWeekModel(weekModel1);
    expect(bloc.getNumberOfMarkedWeekModels(), 1);

    int count = 0;
    bloc.weekModels.listen((List<WeekModel> userWeekModels) {
      if (count == 0) {
        bloc.deleteMarkedWeekModels();
        count++;
      } else {
        expect(userWeekModels.contains(weekModel1), false);
        expect(userWeekModels.length, 0);
        expect(bloc.getNumberOfMarkedWeekModels(), 0);
      }
    });

    done();
  }));

  test('Checks if the edit mode toggles from true', async((DoneFn done) {
    /// Edit mode stream initial value is false.
    bloc.toggleEditMode();

    bloc.editMode.skip(1).listen((bool toggle) {
      expect(toggle, false);
      done();
    });

    bloc.toggleEditMode();
  }));

  test('Check if the week models are sorted by date', async((DoneFn done) {
    final List<WeekModel> correctList = <WeekModel>[
      weekModel5, weekModel4, weekModel1, weekModel3, weekModel2
    ];

    weekNameModelList.add(weekNameModel2);
    weekNameModelList.add(weekNameModel3);
    weekNameModelList.add(weekNameModel4);
    weekNameModelList.add(weekNameModel5);

    weekModelList.add(weekModel2);
    weekModelList.add(weekModel3);
    weekModelList.add(weekModel4);
    weekModelList.add(weekModel5);

    bloc.load(UsernameModel(name: 'test', role: 'test', id: 'test'));

    bloc.weekModels.listen((List<WeekModel>weekModels) {
      expect(correctList, weekModels);
    });
    done();
  }));
}
