import 'package:api_client/api/api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:async_test/async_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_api/test_api.dart';
import 'package:weekplanner/blocs/weekplans_bloc.dart';

class MockWeekApi extends Mock implements WeekApi {}

void main() {
  WeekplansBloc bloc;
  Api api;
  MockWeekApi weekApi;

  final List<WeekNameModel> weekNameModelList = <WeekNameModel>[];
  final WeekNameModel weekNameModel =
      WeekNameModel(name: 'name', weekNumber: 1, weekYear: 1);
  final List<WeekModel> weekModelList = <WeekModel>[];
  final WeekModel weekModel = WeekModel(name: 'weekModel');
  final UsernameModel mockUser =
      UsernameModel(name: 'test', id: 'test', role: 'test');

  void setupApiCalls() {
    weekModelList.add(weekModel);
    weekNameModelList.add(weekNameModel);

    when(weekApi.getNames('test')).thenAnswer(
        (_) => BehaviorSubject<List<WeekNameModel>>.seeded(weekNameModelList));

    when(weekApi.get('test', weekNameModel.weekYear, weekNameModel.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel));

    when(weekApi.delete(mockUser.id, weekModel.weekYear, weekModel.weekNumber))
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

  test('Should dispose weekNameModel stream', async((DoneFn done) {
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
    bloc.toggleMarkedWeekModel(weekModel);
  }));

  test('Removes a weekmodel from the list of marked weekmodels',
      async((DoneFn done) {
    // Add the weekmodel to list of marked weekmodels
    bloc.toggleMarkedWeekModel(weekModel);
    expect(bloc.getNumberOfMarkedWeekModels(), 1);

    bloc.markedWeekModels
        .skip(1)
        .listen((List<WeekModel> markedWeekModelsList) {
      expect(markedWeekModelsList.length, 0);
      done();
    });

    // Remove the weekmodel from the list of marked weekmodels.
    bloc.toggleMarkedWeekModel(weekModel);
  }));

  test('Clear the list of marked weekmodels', async((DoneFn done) {
    // Add the weekmodel to list of marked weekmodels
    bloc.toggleMarkedWeekModel(weekModel);
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
    bloc.toggleMarkedWeekModel(weekModel);
    expect(bloc.getNumberOfMarkedWeekModels(), 1);

    expect(bloc.isWeekModelMarked(weekModel), true);
    done();
  }));

  test('Returns false if a weekmodel is not marked', async((DoneFn done) {
    bloc.toggleMarkedWeekModel(weekModel);
    expect(bloc.getNumberOfMarkedWeekModels(), 1);

    bloc.toggleMarkedWeekModel(weekModel);
    expect(bloc.getNumberOfMarkedWeekModels(), 0);

    expect(bloc.isWeekModelMarked(weekModel), false);
    done();
  }));

  test('Checks if the number of marked weekmodels matches',
      async((DoneFn done) {
    bloc.toggleMarkedWeekModel(weekModel);
    expect(bloc.getNumberOfMarkedWeekModels(), 1);

    bloc.toggleMarkedWeekModel(WeekModel(name: 'testWeekModel'));
    expect(bloc.getNumberOfMarkedWeekModels(), 2);

    bloc.toggleMarkedWeekModel(weekModel);
    expect(bloc.getNumberOfMarkedWeekModels(), 1);
    done();
  }));

  test('Checks if the marked weekmodels are deleted from the weekmodels',
      async((DoneFn done) {
    final List<WeekNameModel> weekNameModelList = <WeekNameModel>[
      weekNameModel
    ];
    when(weekApi.get(
            mockUser.id, weekNameModel.weekYear, weekNameModel.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel));

    when(weekApi.getNames(mockUser.id)).thenAnswer(
        (_) => BehaviorSubject<List<WeekNameModel>>.seeded(weekNameModelList));

    bloc.load(mockUser);
    bloc.toggleMarkedWeekModel(weekModel);
    expect(bloc.getNumberOfMarkedWeekModels(), 1);

    int count = 0;
    bloc.weekModels.listen((List<WeekModel> userWeekModels) {
      if (count == 0) {
        bloc.deleteMarkedWeekModels();
        count++;
      } else {
        expect(userWeekModels.contains(weekModel), false);
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
}
