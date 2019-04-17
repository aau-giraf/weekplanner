import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
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

}