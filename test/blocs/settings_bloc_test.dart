import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';

class MockSettingsApi extends Mock implements UserApi {}

class MockUserApi extends Mock implements UserApi {
  
}

void main() {
  SettingsBloc settingsBloc;
  Api api;
}