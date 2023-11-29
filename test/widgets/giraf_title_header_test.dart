import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

void main() {
  testWidgets('Test that a null title is replaced with empty',
      (WidgetTester tester) async {
    //Pumps a widget containing a GirafTitleHeader with the title "TitleHeader"
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
      body: GirafTitleHeader(title: 'TitleHeader'),
    )));
    await tester.pump();
    //Checks if the text is "TitleHeader"
    expect(find.text('TitleHeader'), findsOneWidget);
  });

  testWidgets('Test that a null title is replaced with empty',
      (WidgetTester tester) async {
    //Pumps a widget containing a GirafTitleHeader with no title assigned"
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
      body: GirafTitleHeader(),
    )));
    await tester.pump();
    //Checks if the text is empty
    expect(find.text(''), findsOneWidget);
  });
}
