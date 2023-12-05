import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

void main() {
  testWidgets('Test that a null title is replaced with empty',
      (WidgetTester tester) async {
    //Pumps a widget containing a GirafTitleHeader with the title "TitleHeader"
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        appBar: GirafTitleHeader(title: 'TitleHeader'),
      ),
    ));
    await tester.pump();
    //Checks if the text is "TitleHeader"
    expect(find.text('TitleHeader'), findsOneWidget);

    expect(find.byType(GirafTitleHeader),
        findsOneWidget); // Forvent at finde GirafTitleHeader
    expect(find.text(''), findsOneWidget); // Forvent at finde en tom streng
  });
}
