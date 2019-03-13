import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

void main() {
  testWidgets('Edit should be invisible', (WidgetTester tester) async {

    ToolbarBloc toolbarBloc = ToolbarBloc();
    await tester.pumpWidget(GirafAppBar());

    final visibilityFinder = find.byType(Visibility);
    final visiblityElements = visibilityFinder.evaluate();

    /*// Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);*/
  });
}