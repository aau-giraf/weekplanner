import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_api/test_api.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:async_test/async_test.dart';
import 'package:weekplanner/providers/api/week_api.dart';

class MockWeekApi extends Mock implements WeekApi {}

final WeekModel sampleModel = WeekModel(
  thumbnail: null,
  name: 'hej',
  days: null,
  weekYear: 2019,
  weekNumber: 42,
);

void main() {
  NewWeekplanBloc bloc;
  Api api;
  MockWeekApi weekApi;

  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    api.week = weekApi;
    bloc = NewWeekplanBloc(api);
  });

  test('Should be able to save a weekplan', async((DoneFn done) {
    when(weekApi.update(
        '1', sampleModel.weekYear, sampleModel.weekNumber, sampleModel))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(sampleModel));
    bloc.save();
//    bloc.load();
  }));

  test('Should validate title', async((DoneFn done) {
    bloc.onTitleChanged('Ugeplan');
    bloc.validTitleStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, true);
      done();
    });
  }));

  test('Should not validate title', async((DoneFn done) {
    bloc.onTitleChanged('');
    bloc.validTitleStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should validate year', async((DoneFn done) {
    bloc.onTitleChanged('Ugeplan');
    bloc.onYearChanged('2004');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, true);
      done();
    });
  }));

  test('Should not validate year', async((DoneFn done) {
    bloc.onYearChanged('218');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate year', async((DoneFn done) {
    bloc.onYearChanged('20019');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate year', async((DoneFn done) {
    bloc.onYearChanged('2O19');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate year', async((DoneFn done) {
    bloc.onYearChanged('');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should validate weekNumber', async((DoneFn done) {
    bloc.onWeekNumberChanged('42');
    bloc.validWeekNumberStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, true);
      done();
    });
  }));

  test('Should not validate weekNumber', async((DoneFn done) {
    bloc.onWeekNumberChanged('0');
    bloc.validWeekNumberStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate weekNumber', async((DoneFn done) {
    bloc.onWeekNumberChanged('54');
    bloc.validWeekNumberStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate weekNumber', async((DoneFn done) {
    bloc.onWeekNumberChanged('-42');
    bloc.validWeekNumberStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should validate all input fields', async((DoneFn done) {
    bloc.onTitleChanged('Ugeplan');
    bloc.onYearChanged('2019');
    bloc.onWeekNumberChanged('42');
    bloc.validInputStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, true);
      done();
    });
  }));

  test('Should not validate all input fields', async((DoneFn done) {
    bloc.onTitleChanged('Ugeplan');
    bloc.onYearChanged('2019');
    bloc.onWeekNumberChanged('-42');
    bloc.validInputStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate all input fields', async((DoneFn done) {
    bloc.onTitleChanged('');
    bloc.onYearChanged('2019');
    bloc.onWeekNumberChanged('42');
    bloc.validInputStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate all input fields', async((DoneFn done) {
    bloc.onTitleChanged('Ugeplan');
    bloc.onYearChanged('218');
    bloc.onWeekNumberChanged('42');
    bloc.validInputStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should reset input streams to default values', async((DoneFn) {
    bloc.onTitleChanged('Ugeplan');
    bloc.onYearChanged('2019');
    bloc.onWeekNumberChanged('42');
    bloc.resetBloc();
  }));

  test('Should dispose stream', async((DoneFn done) {
    bloc.validInputStream.listen((_) {}, onDone: done);
    bloc.dispose();
  }));
}
