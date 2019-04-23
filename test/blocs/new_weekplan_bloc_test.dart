import 'package:api_client/api/api.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:test_api/test_api.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:async_test/async_test.dart';

void main() {
  NewWeekplanBloc bloc;
  Api api;
  PictogramModel thumbnail;

  setUp(() {
    api = Api('any');
    bloc = NewWeekplanBloc(api);
    thumbnail = PictogramModel(
        id: 1,
        lastEdit: null,
        title: null,
        accessLevel: null,
        imageUrl: 'http://any.tld',
        imageHash: null);
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
    bloc.onYearChanged.add('-218');
    bloc.validYearStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate year', async((DoneFn done) {
    bloc.onYearChanged.add(' 218');
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
    bloc.onThumbnailChanged.add(thumbnail);
    bloc.validInputFieldsStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, true);
      done();
    });
  }));

  test('Should not validate all input fields', async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.onYearChanged.add('2019');
    bloc.onWeekNumberChanged.add('-42');
    bloc.onThumbnailChanged.add(thumbnail);
    bloc.validInputFieldsStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate all input fields', async((DoneFn done) {
    bloc.onTitleChanged.add('');
    bloc.onYearChanged.add('2019');
    bloc.onWeekNumberChanged.add('42');
    bloc.onThumbnailChanged.add(thumbnail);
    bloc.validInputFieldsStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should not validate all input fields', async((DoneFn done) {
    bloc.onTitleChanged.add('Ugeplan');
    bloc.onYearChanged.add('218');
    bloc.onWeekNumberChanged.add('42');
    bloc.onThumbnailChanged.add(thumbnail);
    bloc.validInputFieldsStream.listen((bool isValid) {
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
    bloc.validInputFieldsStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, false);
      done();
    });
  }));

  test('Should dispose stream', async((DoneFn done) {
    bloc.validInputFieldsStream.listen((_) {}, onDone: done);
    bloc.dispose();
  }));
}
