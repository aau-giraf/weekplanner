import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

void main() {
  testWidgets('Test that a null title is replaced with empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
      body: GirafTitleHeader(title: 'TitleHeader'),
    )));
    await tester.pump();
    expect(find.text('TitleHeader'), findsOneWidget);
  });

  testWidgets('Test that a null title is replaced with empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
      body: GirafTitleHeader(),
    )));
    await tester.pump();
    expect(find.text(''), findsOneWidget);
  });
}
