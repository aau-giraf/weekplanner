import 'package:api_client/models/username_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/widgets/citizen_avatar_widget.dart';

class MockScreen extends StatelessWidget {
  MockScreen({@required this.callback});

  final VoidCallback callback;
  final UsernameModel usernameModel =
      UsernameModel(name: 'Testname', role: 'Guardian', id: '2');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CitizenAvatar(usernameModel: usernameModel, onPressed: callback),
      ),
    );
  }
}

void main() {
  int i = 0;
  final MockScreen mockScreen = MockScreen(callback: () => ++i);

  testWidgets('Test if citizen text appears', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: mockScreen));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('WidgetText')), findsNWidgets(1));
  });

  testWidgets('Test if citizen avatar appears', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: mockScreen));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('WidgetAvatar')), findsNWidgets(1));
  });

  testWidgets('Test if text is the username', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: mockScreen));
    await tester.pumpAndSettle();
    expect(find.text('Testname'), findsNWidgets(1));
  });

  testWidgets('Test if callback is working on avatar',
      (WidgetTester tester) async {
    i = 0;
    await tester.pumpWidget(MaterialApp(home: mockScreen));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('WidgetAvatar')));
    expect(i, 1);
  });

  testWidgets('Test if callback is working on text',
      (WidgetTester tester) async {
    i = 0;
    await tester.pumpWidget(MaterialApp(home: mockScreen));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('WidgetText')));
    expect(i, 1);
  });
}
