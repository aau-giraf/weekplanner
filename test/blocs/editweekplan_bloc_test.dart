import 'package:api_client/api/api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/blocs/edit_weekplan_bloc.dart';

class MockWeekApi extends Mock implements WeekApi {}

void main() {
  EditWeekplanBloc bloc;
  Api api;
  MockWeekApi weekApi;

  void setupApiCalls() {

  }

  setUp(() {

  });
}