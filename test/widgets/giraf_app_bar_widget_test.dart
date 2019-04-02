import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/api/api.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:mockito/mockito.dart';

class MockAuth extends Mock implements AuthBloc {}

/// Used to retrieve the visibility widget wrapping the editbutton
const String keyOfVisibilityForEdit = 'visibilityEditBtn';

void main() {
  ToolbarBloc bloc;
  Api api;

  setUp(() {
    api = Api('any');
    bloc = ToolbarBloc();

    di.clearAll();
    di.registerDependency<ToolbarBloc>((_) => bloc);
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
  });

  // Used to wrap a widget into a materialapp, otherwise the widget is not
  // testable
  Widget makeTestableWidget ({Widget child})  {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('Has toolbar with title', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(title: 'Ugeplan');

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));

    expect(find.text('Ugeplan'), findsOneWidget);
  });

  testWidgets('Visibility widget should be in widget tree',
             (WidgetTester tester) async {
    // Instantiates the appbar.
    final GirafAppBar girafAppBar = GirafAppBar(title: 'AppBar');

    // Uses the pumpwidget function to build the widget, so it becomes active.
    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));

    // Searches for a widget with a specific key, and we only expect to find one
    expect(find.byKey(const Key(keyOfVisibilityForEdit)), findsOneWidget);

  });

  testWidgets('Visibility widget should not be visible',
             (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(title: 'AppBar');
    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));

    // Retrieves the visiblity widget.
    final Visibility visibility =
        tester.widget(find.byKey(const Key(keyOfVisibilityForEdit)));

    // Should be false, since that is the initial value.
    expect(visibility.visible, false);

  });

  testWidgets('Visibility widget should be visible',
             (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(title: 'AppBar');
    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));

    // Tries to change the value of visiblity.visible, by sending "true" though
    // the stream.
    bloc.setEditVisible(true);

    await tester.pumpAndSettle();
    final Visibility visibility =
        tester.widget(find.byKey(const Key(keyOfVisibilityForEdit)));

    expect(visibility.visible, true);
  });

  testWidgets('Visibility widget toggled', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(title: 'AppBar');
    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));

    bloc.setEditVisible(true);
    await tester.pumpAndSettle();
    Visibility visibility =
        tester.widget(find.byKey(const Key(keyOfVisibilityForEdit)));
    expect(visibility.visible, true);

    bloc.setEditVisible(false);
    await tester.pumpAndSettle();
    visibility = tester.widget(find.byKey(const Key(keyOfVisibilityForEdit)));
    expect(visibility.visible, false);
  });
}