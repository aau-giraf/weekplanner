import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:mockito/mockito.dart';

class MockAuth extends Mock implements AuthBloc {}

void main() {

  Api api;
  MockAuth mockAuth;

  setUp(() {
    api = Api("any");
    mockAuth = MockAuth();
  });


  ///The key for the visibility widget, used to retrieve the widget during testing.
  String keyOfVisibilityForEdit = "visibilityEditBtn";

  ///Used to wrap a widget into a materialapp, otherwise the widget is not
  ///testable
  Widget makeTestableWidget ({Widget child})  {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('Simple test', (WidgetTester tester) async {
    GirafAppBar girafAppBar = GirafAppBar(title: "AppBar");

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));

    expect(find.text('Ugeplan'), findsOneWidget);
  });

  testWidgets('Visibility widget should be in widget tree', (WidgetTester tester) async {

    ///Instantiates the toolbarBloc, which the appbar uses.
    ToolbarBloc toolbarBloc = ToolbarBloc();

    ///Instantiates the appbar.
    GirafAppBar girafAppBar = GirafAppBar(title: "AppBar");

    ///Uses the pumpwidget function to build the widget, so it becomes active.
    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));

    ///Searches for a widget with a specific key, and we only expect to find one.
    expect(find.byKey(Key(keyOfVisibilityForEdit)), findsOneWidget);

  });

  testWidgets('Visibility widget should not be visible', (WidgetTester tester) async {

    ToolbarBloc toolbarBloc = ToolbarBloc();
    GirafAppBar girafAppBar = GirafAppBar(title: "AppBar");
    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));

    ///Retrieves the visiblity widget.
    final Visibility visibility = tester.widget(find.byKey(Key(keyOfVisibilityForEdit)));

    ///Should be false, since that is the initial value.
    expect(visibility.visible, false);

  });

  testWidgets('Visibility widget should be visible', (WidgetTester tester) async {

    ToolbarBloc toolbarBloc = ToolbarBloc();
    GirafAppBar girafAppBar = GirafAppBar(title: "AppBar");
    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));

    final Visibility visibility = tester.widget(find.byKey(Key(keyOfVisibilityForEdit)));

    ///Tries to change the value of visiblity.visible, by sending "true" though
    ///the stream.
    toolbarBloc.setEditVisible(true);

    expect(visibility.visible, true);

  });

}