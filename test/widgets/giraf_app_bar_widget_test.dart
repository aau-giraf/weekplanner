import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/providers/api/api.dart';
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

    di.clearAll();
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    bloc = ToolbarBloc();
    di.registerDependency<ToolbarBloc>((_) => bloc);
  });

  // Used to wrap a widget into a materialapp, otherwise the widget is not
  // testable
  Widget makeTestableWidget({Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('Has toolbar with title', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(title: 'Ugeplan');

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));

    expect(find.text('Ugeplan'), findsOneWidget);
  });

  testWidgets('Display default icons when given no icons to display', (WidgetTester tester) async {
    final GirafAppBar girafAppBar =
        GirafAppBar(title: 'Ugeplan', appBarIcons: null);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();
    expect(find.byTooltip('Log ud'), findsOneWidget);
    expect(find.byTooltip('Indstillinger'), findsOneWidget);
  });

  testWidgets('Change to citizen button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar =
      GirafAppBar(title: 'Ugeplan', appBarIcons: <AppBarIcon>[AppBarIcon.changeToCitizen]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Skift til borger tilstand'), findsOneWidget);
  });
}
