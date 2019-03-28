
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';

import '../blocs/weekplan_bloc_test.dart';

void main(){
  WeekplanBloc weekplanBloc;
  Api api;
  MockWeekApi weekApi;
  WeekModel week = WeekModel(name: 'Week test');

  setUp() {
    

  }

  testWidgets('renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(week: week)));
  });
}