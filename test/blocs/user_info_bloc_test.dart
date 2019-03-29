import 'package:flutter_test/flutter_test.dart';
import 'package:quiver/time.dart';
import 'package:tuple/tuple.dart';
import 'package:weekplanner/blocs/user_info_bloc.dart';



void main() {
  Clock mockClock;

  test('initial value should be \'Guardian\'', () {
    final UserInfoBloc userInfoBloc = UserInfoBloc();

    final Future<String> initialData =
        userInfoBloc.changeUserMode.first.then((String val) => val);
    expect(initialData, 'Guardian');
  });

  test('changeUserMode stream should emit Tuple2<String, int>(\'Guardian\',2',
          () {
    final UserInfoBloc userInfoBloc = UserInfoBloc(mockClock);
    userInfoBloc.setUserMode('Guardian');

    expect(userInfoBloc.changeUserMode, emits('Guardian'));
    expect(userInfoBloc.dayOfWeekAndUsermode,
           emits(const Tuple2<String, int>('Guardian', 2)));
  });

  test('changeUserMode stream should emit Tuple2<String, int>(\'Citizen\',2',
          () {
    mockClock = Clock.fixed(DateTime(2019, 03, 19));
    final UserInfoBloc userInfoBloc = UserInfoBloc(mockClock);
    userInfoBloc.setUserMode('Citizen');

    expect(userInfoBloc.changeUserMode, emits('Citizen'));
    expect(userInfoBloc.dayOfWeekAndUsermode,
           emits(const Tuple2<String, int>('Citizen', 2)));
  });




}