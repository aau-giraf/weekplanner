import 'package:api_client/api/api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/edit_weekplan_bloc.dart';
import 'package:weekplanner/blocs/weekplan_selector_bloc.dart';
import 'package:weekplanner/di.dart';

class MockWeekApi extends Mock implements WeekApi {}

//test functionality for editing a weekplan bloc
void main() {
  EditWeekplanBloc bloc;
  WeekplansBloc mockWeekplanSelector;
  Api api;
  //Create mockup pictogram
  final PictogramModel mockThumbnail = PictogramModel(
      id: 1,
      lastEdit: null,
      title: null,
      accessLevel: null,
      imageUrl: 'http://any.tld',
      imageHash: null);
  final DisplayNameModel mockUser =
      DisplayNameModel(displayName: 'User', id: '1', role: null);
  final WeekModel mockWeek = WeekModel(
      thumbnail: mockThumbnail,
      days: null,
      name: 'Week',
      weekNumber: 1,
      weekYear: DateTime.now().year + 1);

//set up test, defines what values to return on api calls
  setUp(() {
    api = Api('any');
    api.week = MockWeekApi();

    when(api.week.update(any, any, any, any)).thenAnswer((_) {
      return Stream<WeekModel>.value(mockWeek);
    });

    when(api.week.getNames(any)).thenAnswer(
      (_) {
        return Stream<List<WeekNameModel>>.value(<WeekNameModel>[
          WeekNameModel(
              name: mockWeek.name,
              weekNumber: mockWeek.weekNumber,
              weekYear: mockWeek.weekYear),
        ]);
      },
    );

    when(api.week.get(any, any, any)).thenAnswer(
      (_) {
        return Stream<WeekModel>.value(mockWeek);
      },
    );

    when(api.week.delete(mockUser.id, mockWeek.weekYear, mockWeek.weekNumber))
        .thenAnswer((_) => rx_dart.BehaviorSubject<bool>.seeded(true));

    mockWeekplanSelector = WeekplansBloc(api);
    mockWeekplanSelector.load(mockUser);

    di.clearAll();
    di.registerSingleton<WeekplansBloc>(() => mockWeekplanSelector);

    bloc = EditWeekplanBloc(api);
    bloc.initialize(mockUser);
  });

  test('Should save the weekplan with new title', async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.onYearChanged.add('2019');
    bloc.onWeekNumberChanged.add('1');
    bloc.onThumbnailChanged.add(mockThumbnail);
    bloc
        .editWeekPlan(
            screenContext: null,
            oldWeekModel: mockWeek,
            selectorBloc: mockWeekplanSelector)
        .then(
      (WeekModel w) {
        verify(api.week.update(any, any, any, any));
        done();
      },
    );
  }));

  test('Should save the weekplan with new week number', async((DoneFn done) {
    final String year = (DateTime.now().year + 1).toString();
    bloc.onTitleChanged.add('Week');
    bloc.onYearChanged.add(year);
    bloc.onWeekNumberChanged.add('42');
    bloc.onThumbnailChanged.add(mockThumbnail);
    bloc
        .editWeekPlan(
            screenContext: null,
            oldWeekModel: mockWeek,
            selectorBloc: mockWeekplanSelector)
        .then(
      (WeekModel w) {
        verify(api.week.update(any, any, any, any));
        done();
      },
    );
  }));
}
