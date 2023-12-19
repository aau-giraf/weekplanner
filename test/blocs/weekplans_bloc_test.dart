// Limit each test to three seconds, at which point they fail due to timing out.
@Timeout(Duration(seconds: 5))



import 'package:api_client/api/api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:week_of_year/date_week_extensions.dart';
import 'package:weekplanner/blocs/weekplans_bloc.dart';

class MockWeekApi extends Mock implements WeekApi {}

void main() {
  Api api = Api('baseUrl');
  WeekplansBloc bloc = WeekplansBloc(api);
  MockWeekApi weekApi = MockWeekApi();

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
  final WeekNameModel weekNameModel6 =
      WeekNameModel(name: 'name', weekNumber: 8, weekYear: 9999);
  final List<WeekModel> weekModelList = <WeekModel>[];
  final WeekModel weekModel1 = WeekModel(weekNumber: 8, weekYear: 2020);
  final WeekModel weekModel2 = WeekModel(weekNumber: 3, weekYear: 2021);
  final WeekModel weekModel3 = WeekModel(weekNumber: 28, weekYear: 2020);
  final WeekModel weekModel4 = WeekModel(weekNumber: 3, weekYear: 2020);
  final WeekModel weekModel5 = WeekModel(weekNumber: 50, weekYear: 2019);
  final WeekModel weekModel6 = WeekModel(weekNumber: 8, weekYear: 9999);
  final DisplayNameModel mockUser =
      DisplayNameModel(displayName: 'test', id: 'test', role: 'test');

  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    api.week = weekApi;
    bloc = WeekplansBloc(api);

    weekNameModelList.clear();
    weekModelList.clear();

    weekModelList.add(weekModel1);
    weekNameModelList.add(weekNameModel1);
  });

  when(() => weekApi.getNames('test')).thenAnswer((_) =>
      rx_dart.BehaviorSubject<List<WeekNameModel>?>.seeded(weekNameModelList));

  when(() => weekApi.get(
          'test', weekNameModel1.weekYear!, weekNameModel1.weekNumber!))
      .thenAnswer((_) => rx_dart.BehaviorSubject<WeekModel>.seeded(weekModel1));

  when(() => weekApi.get(
          'test', weekNameModel2.weekYear!, weekNameModel2.weekNumber!))
      .thenAnswer((_) => rx_dart.BehaviorSubject<WeekModel>.seeded(weekModel2));

  when(() => weekApi.get(
          'test', weekNameModel3.weekYear!, weekNameModel3.weekNumber!))
      .thenAnswer((_) => rx_dart.BehaviorSubject<WeekModel>.seeded(weekModel3));

  when(() => weekApi.get(
          'test', weekNameModel4.weekYear!, weekNameModel4.weekNumber!))
      .thenAnswer((_) => rx_dart.BehaviorSubject<WeekModel>.seeded(weekModel4));

  when(() => weekApi.get(
          'test', weekNameModel5.weekYear!, weekNameModel5.weekNumber!))
      .thenAnswer((_) => rx_dart.BehaviorSubject<WeekModel>.seeded(weekModel5));

  when(() => weekApi.get(
          'test', weekNameModel6.weekYear!, weekNameModel6.weekNumber!))
      .thenAnswer((_) => rx_dart.BehaviorSubject<WeekModel>.seeded(weekModel6));

  when(() => weekApi.delete(any(), any(), any()))
      .thenAnswer((_) => rx_dart.BehaviorSubject<bool>.seeded(true));

  when(() => weekApi.delete(any(), any(), any()))
      .thenAnswer((_) => rx_dart.BehaviorSubject<bool>.seeded(true));



  test('Should be able to load weekplans for a user', async((DoneFn done) {
    when(() => weekApi.get(
            mockUser.id!, weekNameModel1.weekYear!, weekNameModel1.weekNumber!))
        .thenAnswer(
            (_) => rx_dart.BehaviorSubject<WeekModel>.seeded(weekModel1));

    when(() => weekApi.getNames(mockUser.id!)).thenAnswer((_) =>
        rx_dart.BehaviorSubject<List<WeekNameModel>>.seeded(weekNameModelList));

    // Checks if the loaded weekNameModels are not null and are equal to the
    // expected weekName model list
    bloc.weekNameModels.listen((List<WeekNameModel>? response) {
      expect(response, isNotNull);
      expect(response, equals(weekNameModelList));
    });

    // Checks if the response of oldWeekModels are not null and are equal to the
    // expected weekmodelList
    bloc.oldWeekModels.listen((List<WeekModel> response) {
      expect(response, isNotNull);
      expect(response, equals(weekModelList));
      done();
    });

    // Loads the mockUser with the WeekNameModel and OldWeekModels. This should
    // trigger the listeners
    bloc.load(mockUser);
  }));

  test('Should dispose weekModels stream', async((DoneFn done) {
    // Checks to see if the 'weekModels' stream is closed.
    // This is done by the function defined by the 'onDone' attribute,
    // which runs every time a stream is closed. If this function is never run,
    // and thus the stream never closes, the test fails due to timeout.
    bloc.weekModels.listen((_) {}, onDone: () {
      // Validate that the stream is actually empty.
      // If this is the case, then the 'done' function is run, ending the test.
      bloc.weekModels.isEmpty.then((bool isEmpty) {
        expect(isEmpty, true);
        done();
      });
    });

    // Dispose the bloc, which should close the 'weekModels' stream.
    bloc.dispose();
  }));

  test('Should dispose weekNameModel stream', async((DoneFn done) {
    // Checks to see if the 'weekNameModels' stream is closed.
    // This is done by the function defined by the 'onDone' attribute,
    // which runs every time a stream is closed. If this function is never run,
    // and thus the stream never closes, the test fails due to timeout.
    bloc.weekNameModels.listen((_) {}, onDone: () {
      // Validate that the stream is actually empty.
      // If this is the case, then the 'done' function is run, ending the test.
      bloc.weekNameModels.isEmpty.then((bool isEmpty) {
        expect(isEmpty, true);
        done();
      });
    });

    // Dispose the bloc, which should close the 'weekNameModels' stream.
    bloc.dispose();
  }));

  test('Adds a weekmodel to a list of marked weekmodels', async((DoneFn done) {
    //Listener fires when an Activity is added.
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
    //Listener fires when a change is made to MarkedWeekModelsList
    //expects that markedWeekModelsList length is = 0

    bloc.markedWeekModels
        .skip(1)
        .listen((List<WeekModel> markedWeekModelsList) {
      expect(markedWeekModelsList.length, 0);
      done();
    });

    // Toggles the weekmodel from the list of marked weekmodels.
    // Should remove the unmarked weekmodel

    bloc.toggleMarkedWeekModel(weekModel1);
  }));

  test('Clear the list of marked weekmodels', async((DoneFn done) {
    // Add the weekmodel to list of marked weekmodels
    bloc.toggleMarkedWeekModel(weekModel1);
    expect(bloc.getNumberOfMarkedWeekModels(), 1);
    //Listener fires when a change is made to MarkedWeekModelsList
    //expects that markedWeekModelsList length is = 0
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
    //Marks weekModel 1
    bloc.toggleMarkedWeekModel(weekModel1);
    //Expects there to be one marked WeekModel on bloc
    expect(bloc.getNumberOfMarkedWeekModels(), 1);
    //Expect marked weekModel to be weekModel1
    expect(bloc.isWeekModelMarked(weekModel1), true);
    done();
  }));

  test('Returns false if a weekmodel is not marked', async((DoneFn done) {
    // Mark weekModel1
    bloc.toggleMarkedWeekModel(weekModel1);
    //Expects there to be one marked WeekModel on bloc
    expect(bloc.getNumberOfMarkedWeekModels(), 1);
    //Un-marks weekModel1
    bloc.toggleMarkedWeekModel(weekModel1);
    //Expects there to be 0 marked WeekModel on bloc
    expect(bloc.getNumberOfMarkedWeekModels(), 0);
    //checks if weekModel1 is still marked
    expect(bloc.isWeekModelMarked(weekModel1), false);
    done();
  }));

  test('Checks if the number of marked weekmodels matches',
      async((DoneFn done) {
    //This test checks if the number of marked weekmodels matches
    //This is done by adding and removing marked weekmodels, and check if
    // the correct number of weekmodels exists
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
    // Creates a list of weekNameModels with one weekNameModel
    final List<WeekNameModel> weekNameModelList = <WeekNameModel>[
      weekNameModel1
    ];
    // Gets a mockUser id, WeekNameModel1s yeah and weekNumber
    // Then anwsers with the seeded WeekNameModel form the list
    when(() => weekApi.get(
            mockUser.id!, weekNameModel1.weekYear!, weekNameModel1.weekNumber!))
        .thenAnswer(
            (_) => rx_dart.BehaviorSubject<WeekModel>.seeded(weekModel1));
    // Gets the id of the mockUser and answers with the
    // seeded weekNameModelList
    when(() => weekApi.getNames(mockUser.id!)).thenAnswer((_) =>
        rx_dart.BehaviorSubject<List<WeekNameModel>>.seeded(weekNameModelList));
    //loads the mockUser, toggles weekModel1 and checks how many
    // weekModels are marked
    bloc.load(mockUser);
    bloc.toggleMarkedWeekModel(weekModel1);
    expect(bloc.getNumberOfMarkedWeekModels(), 1);
    //When the listener fires, first delete the marked weeks from the list
    // then sets the count to 1
    // When its fired again, it expects that userWeekModels doesn't contain
    // weekModel1, that userWeekModels has a length of 0 and the bloc has 0
    // marked weekModels

    int count = 0;
    bloc.weekModels.listen((List<WeekModel> userWeekModels) {
      if (count == 0) {
        bloc.deleteMarkedWeekModels();
        count++;
      } else {
        expect(userWeekModels.contains(weekModel1), true);
        expect(userWeekModels.length, 0);
        expect(bloc.getNumberOfMarkedWeekModels(), 0);
      }
    });

    done();
  }));

  test('check deletion of new weekplan without oldWeekPlan',
      async((DoneFn done) {
    // Creates a list of weekNameModels with one weekNameModel

    final List<WeekNameModel> weekNameModelList = <WeekNameModel>[
      weekNameModel6
    ];
    // Gets a mockUser id, WeekNameModel6s yeah and weekNumber
    // Then anwsers with the seeded WeekNameModel form the list
    when(() => weekApi.get(
            mockUser.id!, weekNameModel6.weekYear!, weekNameModel6.weekNumber!))
        .thenAnswer(
            (_) => rx_dart.BehaviorSubject<WeekModel>.seeded(weekModel6));
    // Gets the id of the mockUser and answers with the
    // seeded weekNameModelList
    when(() => weekApi.getNames(mockUser.id!)).thenAnswer((_) =>
        rx_dart.BehaviorSubject<List<WeekNameModel>>.seeded(weekNameModelList));

    //loads the mockUser, toggles weekModel6 and checks how many
    // weekModels are marked

    bloc.load(mockUser);
    bloc.toggleMarkedWeekModel(weekModel6);
    expect(bloc.getNumberOfMarkedWeekModels(), 1);

    //When the listener fires, first delete the marked weeks from the list
    // then sets the count to 1
    // When its fired again, it expects that userWeekModels doesn't contain
    // weekModel6, that userWeekModels has a length of 0 and the bloc has 0
    // marked weekModels
    int count = 0;
    bloc.weekModels.listen((List<WeekModel> userWeekModels) {
      if (count == 0) {
        count++;
      } else {
        expect(userWeekModels.contains(weekModel6), false);
        expect(userWeekModels.length, 0);
        expect(bloc.getNumberOfMarkedWeekModels(), 0);
      }
    });

    done();
  }));






  test('Checks if the edit mode toggles from true', async((DoneFn done) {
    /// Edit mode stream initial value is false.
    bloc.toggleEditMode();
    //Checks if the edit mode toggle functions can toggle of.
    bloc.editMode.skip(1).listen((bool toggle) {
      expect(toggle, false);
      done();
    });

    bloc.toggleEditMode();
  }));

  /// Method adds weekModel to the _weekModel stream
  void addWeekModel(WeekModel weekModel) {
    bloc.addWeekModels(<WeekModel>[weekModel]);
  }

  /// Method adds weekModel to the _oldWeekModel stream
  void addOldWeekModel(WeekModel weekModel) {
    bloc.addOldWeekModels(<WeekModel>[weekModel]);
  }

  /// Method to handle adding a weekModel
  void handleAddWeekModels(WeekModel weekModel) {
    // If weekModel is in weekModelList, add weekModel to _oldWeekModel stream
    if (weekModelList.contains(weekModel)) {
      addOldWeekModel(weekModel);
    } else {
      // If weekModel is not in weekModelList, add weekModel to _weekModel stream
      addWeekModel(weekModel);
    }
  }

  test('Check if the week models are sorted by date',
      async((DoneFn done) async {
        final List<WeekModel> correctListOld = <WeekModel>[
          weekModel1,
          weekModel4,
          weekModel5
        ];
        final List<WeekModel> correctListUpcoming = <WeekModel>[
          weekModel2,
          weekModel3,
        ];

        weekModelList.add(weekModel4);
        weekModelList.add(weekModel5);

        handleAddWeekModels(weekModel1);
        handleAddWeekModels(weekModel2);
        handleAddWeekModels(weekModel3);
        handleAddWeekModels(weekModel4);
        handleAddWeekModels(weekModel5);

        // Check upcoming List
        bloc.weekModels.listen((List<WeekModel> weekModels) {
          expect(correctListUpcoming, weekModels);
        });

        // Check old List
        bloc.oldWeekModels.listen((List<WeekModel> oldWeekModels) {
          expect(correctListOld, oldWeekModels);
        });

        done();
      }));

  /// test addWeekModel method added to this class
  test('addWeekModel adds a weekModel to the _weekModel stream',
      async((DoneFn done) async {
        final WeekModel weekModel1 = WeekModel();
        final WeekModel weekModel2 = WeekModel();

        addWeekModel(weekModel1);
        addWeekModel(weekModel2);

        bloc.weekModels.listen((List<WeekModel> weekModels) {
          expect(weekModels, contains(weekModel1));
          expect(weekModels, contains(weekModel2));
          done();
        });
      }));

  /// test addOldWeekModel method added to this class
  test('addOldWeekModel adds a weekModel to the _oldWeekModel stream',
      async((DoneFn done) async {
        final WeekModel weekModel3 = WeekModel();
        final WeekModel weekModel4 = WeekModel();

        addOldWeekModel(weekModel3);
        addOldWeekModel(weekModel4);

        bloc.oldWeekModels.listen((List<WeekModel> oldWeekModels) {
          expect(oldWeekModels, contains(weekModel3));
          expect(oldWeekModels, contains(weekModel4));
          done();
        });
      }));

  test('Test marked week models', async((DoneFn done) {
    final List<WeekModel> correctMarked = <WeekModel>[
      weekModel1,
      weekModel2,
      weekModel3
    ];
    //Toggles three weekModels and checks that they are equal to correctMarked
    bloc.toggleMarkedWeekModel(weekModel1);
    bloc.toggleMarkedWeekModel(weekModel2);
    bloc.toggleMarkedWeekModel(weekModel3);
    expect(bloc.getMarkedWeekModels(), correctMarked);
    done();
  }));

  test('Test if package works', async((DoneFn done) { 
    
    final int currentWeek = DateTime.now().weekOfYear;
    
    expect(currentWeek, 50);

    done();
    
  }));

  test('Weekplans should be split into old and upcoming', async((DoneFn done) {
    weekModelList.clear();
    weekModelList.add(weekModel2);
    weekModelList.add(weekModel3);

    weekNameModelList.clear();
    handleAddWeekModels(weekModel1);
    handleAddWeekModels(weekModel2);
    handleAddWeekModels(weekModel3);
    handleAddWeekModels(weekModel4);
    handleAddWeekModels(weekModel5);

    // Check upcoming List
    bloc.weekModels.listen((List<WeekModel> listUpcoming) {
      expect(listUpcoming.contains(weekModel1), true);
      expect(listUpcoming.contains(weekModel2), false);
      expect(listUpcoming.contains(weekModel3), false);
      expect(listUpcoming.contains(weekModel4), true);
      expect(listUpcoming.contains(weekModel5), true);
    });

    // Check old List
    bloc.oldWeekModels.listen((List<WeekModel> oldWeekModels) {
      expect(oldWeekModels.contains(weekModel1), false);
      expect(oldWeekModels.contains(weekModel2), true);
      expect(oldWeekModels.contains(weekModel3), true);
      expect(oldWeekModels.contains(weekModel4), false);
      expect(oldWeekModels.contains(weekModel5), false);
    });

    done();
  }));

}
