import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  GirafNotifyDialog dialog = GirafNotifyDialog(
      title: 'TestingTitle',
      description: 'This description is for testing',
  );
  const String okayBtnKey = 'NotifyDialogOkayButton';

  testWidgets('Notify dialog pops on confirmation',
          (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: dialog,
      )
    );

    Visibility visibility = tester.widget(
        find.byKey(const Key(okayBtnKey)));

    expect(visibility.visible, true);
    await tester.pumpAndSettle();
    await tester.press(find.byKey(const Key(okayBtnKey)));
    await tester.pumpAndSettle();
    visibility = tester.widget(find.byKey(const Key(okayBtnKey)));

    expect(visibility.visible, false);
  });


}
