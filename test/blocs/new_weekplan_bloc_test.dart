// import 'package:flutter/material.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:test_api/test_api.dart';
// import 'package:mockito/mockito.dart';
// import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
// import 'package:weekplanner/models/pictogram_model.dart';
// import 'package:weekplanner/models/week_model.dart';
// import 'package:weekplanner/providers/api/api.dart';
// import 'package:async_test/async_test.dart';
// import 'package:weekplanner/providers/api/week_api.dart';

// class MockWeekApi extends Mock implements WeekApi {}

// final WeekModel sampleModel = WeekModel(
//   thumbnail: null,
//   name: null,
//   days: null,
//   weekYear: null,
//   weekNumber: null,
// );

// void main() {
//   NewWeekplanBloc bloc;
//   Api api;
//   MockWeekApi weekApi;

//   setUp(() {
//     api = Api('any');
//     weekApi = MockWeekApi();
//     api.week = weekApi;
//     bloc = NewWeekplanBloc(api);
//     bloc.onTitleChanged('Ugeplan');
//     bloc.onYearChanged('2001');
//     bloc.onWeekNumberChanged('10');
//   });

//   test('Should be able to save weekplan', async((DoneFn done) {
//     final WeekModel model = WeekModel(
//       thumbnail: null,
//       name: null,
//       days: null,
//       weekYear: null,
//       weekNumber: null,
//     );

//     when(weekApi.update('1', model.weekYear, model.weekNumber, model))
//         .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(sampleModel));

//     bloc.save();

//     bloc.load();
//   }));

//   test('Should validate title', async((DoneFn done) {
//     bloc.onTitleChanged('Ugeplan');
//     bloc.validInputStream.listen((bool isValid) {
//       expect(isValid, isNotNull);
//       expect(isValid, true);
//       done();
//     });
//   }));

//   test('Should not validate title', async((DoneFn done) {
//     bloc.onTitleChanged('');
//     bloc.validInputStream.listen((bool isValid) {
//       expect(isValid, isNotNull);
//       expect(isValid, false);
//       done();
//     });
//   }));

//     test('Should validate year', async((DoneFn done) {
//     bloc.onTitleChanged('Ugeplan');
//     bloc.onYearChanged('2004');
//     bloc.validInputStream.listen((bool isValid) {
//       expect(isValid, isNotNull);
//       expect(isValid, true);
//       done();
//     });

//     test('Should not validate year', async((DoneFn done) {
//     bloc.onYearChanged('19');
//     bloc.validInputStream.listen((bool isValid) {
//       expect(isValid, isNotNull);
//       expect(isValid, false);
//       done();
//     });

//     test('Should validate weekNumber', async((DoneFn done) {
//     bloc.onYearChanged('2013');
//     bloc.validInputStream.listen((bool isValid) {
//       expect(isValid, isNotNull);
//       expect(isValid, false);
//       done();
//     });

//     test('Should not validate weekNumber', async((DoneFn done) {
//     bloc.onYearChanged('0');
//     bloc.validInputStream.listen((bool isValid) {
//       expect(isValid, isNotNull);
//       expect(isValid, false);
//       done();
//     });
//   }));

//   test('Should dispose stream', async((DoneFn done) {
//     bloc.validInputStream.listen((_) {}, onDone: done);
//     bloc.dispose();
//   }));
// }
