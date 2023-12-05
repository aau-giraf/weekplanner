import 'package:api_client/models/displayname_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/widgets/citizen_avatar_widget.dart';

//Creates a mock for the test
class MockScreen extends StatelessWidget {
  MockScreen({required this.callback});

  final VoidCallback callback;
  final DisplayNameModel usernameModel =
      DisplayNameModel(displayName: 'Testname', role: 'Guardian', id: '2');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:
            CitizenAvatar(displaynameModel: usernameModel, onPressed: callback),
      ),
    );
  }
}

void main() {
  //Setting up the environment
  int i = 0;
  const Key widgetAvatar = Key('WidgetAvatar');
  const Key widgetText = Key('WidgetText');
  final MockScreen mockScreen = MockScreen(callback: () => ++i);

  testWidgets('Test if citizen text appears', (WidgetTester tester) async {
    //Pumps the mockScreen until there are no more frames scheduled
    await tester.pumpWidget(MaterialApp(home: mockScreen));
    await tester.pumpAndSettle();
    //Checks if it can find the text (widgetText)
    expect(find.byKey(widgetText), findsOneWidget);
  });

  testWidgets('Test if citizen avatar appears', (WidgetTester tester) async {
    //Pumps the mockScreen until there are no more frames scheduled
    await tester.pumpWidget(MaterialApp(home: mockScreen));
    await tester.pumpAndSettle();
    //Checks if it can find the citizen avatar (widgetAvatar)
    expect(find.byKey(widgetAvatar), findsOneWidget);
  });

  testWidgets('Test if text is the username', (WidgetTester tester) async {
    //Pumps the mockScreen until there are no more frames scheduled
    await tester.pumpWidget(MaterialApp(home: mockScreen));
    await tester.pumpAndSettle();
    //Checks if "Testname" is the username
    expect(find.text('Testname'), findsOneWidget);
  });

  testWidgets('Test if callback is working on avatar',
      (WidgetTester tester) async {
    i = 0;
    //Pumps the mockScreen until there are no more frames scheduled
    await tester.pumpWidget(MaterialApp(home: mockScreen));
    await tester.pumpAndSettle();
    //Uses tester.tap to check if callback works when clicking on an avatar
    await tester.tap(find.byKey(widgetAvatar));
    //If it works "i" would have been iterated to 1 and the assert will be true
    expect(i, 1);
  });

  testWidgets('Test if callback is working on text',
      (WidgetTester tester) async {
    i = 0;
    //Pumps the mockScreen until there are no more frames scheduled
    await tester.pumpWidget(MaterialApp(home: mockScreen));
    await tester.pumpAndSettle();
    //Uses tester.tap to check if callback works when clicking on an avatar
    await tester.tap(find.byKey(widgetText));
    //If it works "i" would have been iterated to 1 and the assert will be true
    expect(i, 1);
  });
}
