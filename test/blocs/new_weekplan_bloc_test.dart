import 'package:api_client/api/api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_api/test_api.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:async_test/async_test.dart';

class MockWeekApi extends Mock implements WeekApi {}

void main() {
  NewWeekplanBloc bloc;
  Api api;
  final PictogramModel thumbnail = PictogramModel(
      id: 1,
      lastEdit: null,
      title: null,
      accessLevel: null,
      imageUrl: 'http://any.tld',
      imageHash: null);
  final UsernameModel user = UsernameModel(name: 'User', id: '1', role: null);
  final WeekModel week = WeekModel(
      thumbnail: thumbnail,
      days: null,
      name: 'Week',
      weekNumber: 1,
      weekYear: 2019);

  setUp(() {
    api = Api('any');
    api.week = MockWeekApi();
    bloc = NewWeekplanBloc(api);
    bloc.initialize(user);

    when(api.week.update(any, any, any, any)).thenAnswer((_) {
      return Observable<WeekModel>.just(week);
    });
  });

  test('Should save the new weekplan', async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.onYearChanged.add('2019');
    bloc.onWeekNumberChanged.add('42');
    bloc.onThumbnailChanged.add(thumbnail);
    bloc.saveWeekplan();

    verify(api.week.update(any, any, any, any));
    done();
  }));

  test('Should validate title: Ugeplan', async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.validTitleStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, true);
      done();
    });
  }));

  test('Should not validate title: [empty string]', async((DoneFn done) {
    bloc.onTitleChanged.add('');
    bloc.validTitleStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should validate year: 2019', async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.onYearChanged.add('2019');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, true);
      done();
    });
  }));

  test('Should validate year: 1990',
      async((DoneFn done) {
    bloc.onYearChanged.add('1990');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, true);
      done();
    });
  }));

  test('Should not validate year: 1',
      async((DoneFn done) {
    bloc.onYearChanged.add('1');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate year: four characters one is a letter',
      async((DoneFn done) {
    bloc.onYearChanged.add('2k01');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate year: negative value for year',
      async((DoneFn done) {
    bloc.onYearChanged.add('-2019');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate year: [empty string]', async((DoneFn done) {
    bloc.onYearChanged.add('');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should validate weekNumber: 42', async((DoneFn done) {
    bloc.onWeekNumberChanged.add('42');
    bloc.validWeekNumberStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, true);
      done();
    });
  }));

  test('Should not validate weekNumber: 0', async((DoneFn done) {
    bloc.onWeekNumberChanged.add('0');
    bloc.validWeekNumberStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate weekNumber: 54', async((DoneFn done) {
    bloc.onWeekNumberChanged.add('54');
    bloc.validWeekNumberStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate weekNumber: -42', async((DoneFn done) {
    bloc.onWeekNumberChanged.add('-42');
    bloc.validWeekNumberStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should see all inputs as valid when they are valid individually',
      async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.onYearChanged.add('2019');
    bloc.onWeekNumberChanged.add('42');
    bloc.onThumbnailChanged.add(thumbnail);
    bloc.allInputsAreValidStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, true);
      done();
    });
  }));

  test('Should not see all inputs as valid when week number is invalid',
      async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.onYearChanged.add('2019');
    bloc.onWeekNumberChanged.add('-42');
    bloc.onThumbnailChanged.add(thumbnail);
    bloc.allInputsAreValidStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not see all inputs as valid when title is invalid',
      async((DoneFn done) {
    bloc.onTitleChanged.add('');
    bloc.onYearChanged.add('2019');
    bloc.onWeekNumberChanged.add('42');
    bloc.onThumbnailChanged.add(thumbnail);
    bloc.allInputsAreValidStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not see all inputs as valid when thumbnail is missing',
      async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.onYearChanged.add('2019');
    bloc.onWeekNumberChanged.add('42');
    bloc.onThumbnailChanged.add(null);
    bloc.allInputsAreValidStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should reset input streams to default values', async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.onYearChanged.add('2019');
    bloc.onWeekNumberChanged.add('42');
    bloc.onThumbnailChanged.add(thumbnail);
    bloc.resetBloc();
    bloc.allInputsAreValidStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should dispose stream', async((DoneFn done) {
    bloc.allInputsAreValidStream.listen((_) {}, onDone: done);
    bloc.dispose();
  }));
}
