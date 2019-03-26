import 'package:flutter_test/flutter_test.dart';
import 'package:quiver/time.dart';
import 'package:tuple/tuple.dart';

import 'package:weekplanner/blocs/user_info_bloc.dart';



void main() {
  final Clock mockClock = Clock.fixed(DateTime(2019, 03, 19));

  test('initial value should be \'Guardian\'', () {
    final UserInfoBloc userInfoBloc = new UserInfoBloc();

    final initialData = userInfoBloc.changeUserMode.first.then((val) => val);
    expect(initialData, 'Guardian');
  });

  test('changeUserMode stream should emit Tuple2<String, int>(\'Guardian\',2', () {
    final UserInfoBloc userInfoBloc = new UserInfoBloc(mockClock);
    userInfoBloc.setUserMode('Guardian');

    expect(userInfoBloc.changeUserMode, emits('Guardian'));
    expect(userInfoBloc.dayOfWeekAndUsermode, emits(Tuple2('Guardian', 2)));
  });

  test('changeUserMode stream should emit Tuple2<String, int>(\'Citizen\',2', () {
    final Clock mockClock = Clock.fixed(DateTime(2019, 03, 19));
    final UserInfoBloc userInfoBloc = new UserInfoBloc(mockClock);
    userInfoBloc.setUserMode('Citizen');

    expect(userInfoBloc.changeUserMode, emits('Citizen'));
    expect(userInfoBloc.dayOfWeekAndUsermode, emits(Tuple2('Citizen', 2)));
  });




}