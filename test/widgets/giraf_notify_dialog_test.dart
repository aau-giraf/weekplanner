import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  const GirafNotifyDialog dialog = GirafNotifyDialog(
    title: 'TestingTitle',
    description: 'This description is for testing',
  );
  const String okayBtnKey = 'NotifyDialogOkayButton';
  //TODO(msimon16): Missing tests for Notify dialog. Tests to be done: Confirm dialog closes on buttonpress, https://github.com/aau-giraf/weekplanner/issues/88

  /*
  testWidgets('Notify dialog pops on confirmation',
          (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: dialog,
      )
    );
    await tester.pump(Duration(milliseconds: 500));
    await tester.tap(find.byKey(const Key(okayBtnKey)));
    await tester.pump(Duration(milliseconds: 500));
    expect(find.byType(GirafNotifyDialog), findsNothing);
  });
*/

}
