import 'package:test_api/test_api.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:async_test/async_test.dart';

void main() {
  NewWeekplanBloc bloc;
  Api api;

  setUp(() {
    api = Api('any');
    bloc = NewWeekplanBloc(api);
  });

  test('Should validate title', async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.validTitleStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, true);
      done();
    });
  }));

  test('Should not validate title', async((DoneFn done) {
    bloc.onTitleChanged.add('');
    bloc.validTitleStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should validate year', async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.onYearChanged.add('2004');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, true);
      done();
    });
  }));

  test('Should not validate year', async((DoneFn done) {
    bloc.onYearChanged.add('218');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate year', async((DoneFn done) {
    bloc.onYearChanged.add('20019');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate year', async((DoneFn done) {
    bloc.onYearChanged.add('2O19');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate year', async((DoneFn done) {
    bloc.onYearChanged.add('');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should validate weekNumber', async((DoneFn done) {
    bloc.onWeekNumberChanged.add('42');
    bloc.validWeekNumberStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, true);
      done();
    });
  }));

  test('Should not validate weekNumber', async((DoneFn done) {
    bloc.onWeekNumberChanged.add('0');
    bloc.validWeekNumberStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate weekNumber', async((DoneFn done) {
    bloc.onWeekNumberChanged.add('54');
    bloc.validWeekNumberStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate weekNumber', async((DoneFn done) {
    bloc.onWeekNumberChanged.add('-42');
    bloc.validWeekNumberStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should validate all input fields', async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.onYearChanged.add('2019');
    bloc.onWeekNumberChanged.add('42');
    bloc.validInputStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, true);
      done();
    });
  }));

  test('Should not validate all input fields', async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.onYearChanged.add('2019');
    bloc.onWeekNumberChanged.add('-42');
    bloc.validInputStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate all input fields', async((DoneFn done) {
    bloc.onTitleChanged.add('');
    bloc.onYearChanged.add('2019');
    bloc.onWeekNumberChanged.add('42');
    bloc.validInputStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate all input fields', async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.onYearChanged.add('218');
    bloc.onWeekNumberChanged.add('42');
    bloc.validInputStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should reset input streams to default values', async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.onYearChanged.add('2019');
    bloc.onWeekNumberChanged.add('42');
    bloc.resetBloc();
    bloc.validInputStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should dispose stream', async((DoneFn done) {
    bloc.validInputStream.listen((_) {}, onDone: done);
    bloc.dispose();
  }));
}
