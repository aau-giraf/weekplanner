import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/week_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/models/user_week_model.dart';

void main() {
  test('Can add week and user', () {
    final WeekModel week = WeekModel();
    final DisplayNameModel user = DisplayNameModel(
      displayName: 'User',
      role: Role.Guardian.toString(),
      id: '1'
    );

    final UserWeekModel userWeek = UserWeekModel(week, user);

    expect(week, userWeek.user);
    expect(user, userWeek.user);
  });
}
