import 'package:api_client/api/api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/edit_weekplan_bloc.dart';
import 'package:async_test/async_test.dart';
import 'package:weekplanner/blocs/weekplan_selector_bloc.dart';
import 'package:weekplanner/di.dart';

class MockWeekApi extends Mock implements WeekApi {}

void main() {
  EditWeekplanBloc bloc;
  WeekplansBloc mockWeekplanSelector;
  Api api;
  final PictogramModel mockThumbnail = PictogramModel(
      id: 1,
      lastEdit: null,
      title: null,
      accessLevel: null,
      imageUrl: 'http://any.tld',
      imageHash: null);
  final UsernameModel mockUser =
      UsernameModel(name: 'User', id: '1', role: null);
  final WeekModel mockWeek = WeekModel(
      thumbnail: mockThumbnail,
      days: null,
      name: 'Week',
      weekNumber: 1,
      weekYear: 2019);

  setUp(() {
    api = Api('any');
    api.week = MockWeekApi();

    when(api.week.update(any, any, any, any)).thenAnswer((_) {
      return Observable<WeekModel>.just(mockWeek);
    });

    when(api.week.getNames(any)).thenAnswer(
      (_) {
        return Observable<List<WeekNameModel>>.just(<WeekNameModel>[
          WeekNameModel(
              name: mockWeek.name,
              weekNumber: mockWeek.weekNumber,
              weekYear: mockWeek.weekYear),
        ]);
      },
    );

    when(api.week.get(any, any, any)).thenAnswer(
      (_) {
        return Observable<WeekModel>.just(mockWeek);
      },
    );


    mockWeekplanSelector = WeekplansBloc(api);
    mockWeekplanSelector.load(mockUser);

    di.clearAll();
    di.registerSingleton<WeekplansBloc>((_) => mockWeekplanSelector);

    bloc = EditWeekplanBloc(api);
    bloc.initialize(mockUser);
  });

  test('Should save the new weekplan', async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.onYearChanged.add('2019');
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
