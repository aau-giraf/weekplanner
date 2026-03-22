import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weekplanner/features/auth/presentation/login_cubit.dart';
import 'package:weekplanner/features/auth/presentation/login_state.dart';
import 'package:weekplanner/features/auth/presentation/views/login_view.dart';

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

void main() {
  late MockLoginCubit mockCubit;

  setUp(() {
    mockCubit = MockLoginCubit();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider<LoginCubit>.value(
        value: mockCubit,
        child: const LoginView(),
      ),
    );
  }

  group('LoginView', () {
    testWidgets('renders form fields in initial state', (tester) async {
      when(() => mockCubit.state).thenReturn(const LoginInitial());

      await tester.pumpWidget(buildSubject());

      expect(find.text('GIRAF Ugeplan'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Brugernavn'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Adgangskode'), findsOneWidget);
      expect(find.text('Husk mig'), findsOneWidget);
      expect(find.text('Log ind'), findsOneWidget);
    });

    testWidgets('shows spinner during loading state', (tester) async {
      when(() => mockCubit.state).thenReturn(const LoginLoading(
        email: 'test@example.com',
        password: 'pass',
        rememberMe: false,
      ));

      await tester.pumpWidget(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Button should be disabled (no 'Log ind' text visible since spinner replaces it)
      expect(find.text('Log ind'), findsNothing);
    });

    testWidgets('shows error message in failure state', (tester) async {
      when(() => mockCubit.state).thenReturn(const LoginFailure(
        message: 'Forkert brugernavn eller adgangskode',
        email: 'test@example.com',
        password: 'wrong',
        rememberMe: false,
      ));

      await tester.pumpWidget(buildSubject());

      expect(
        find.text('Forkert brugernavn eller adgangskode'),
        findsOneWidget,
      );
    });

    testWidgets('calls emailChanged when username field changes',
        (tester) async {
      when(() => mockCubit.state).thenReturn(const LoginInitial());
      when(() => mockCubit.emailChanged(any())).thenReturn(null);

      await tester.pumpWidget(buildSubject());
      await tester.enterText(
          find.widgetWithText(TextField, 'Brugernavn'), 'hello');

      verify(() => mockCubit.emailChanged('hello')).called(1);
    });

    testWidgets('calls passwordChanged when password field changes',
        (tester) async {
      when(() => mockCubit.state).thenReturn(const LoginInitial());
      when(() => mockCubit.passwordChanged(any())).thenReturn(null);

      await tester.pumpWidget(buildSubject());
      await tester.enterText(
          find.widgetWithText(TextField, 'Adgangskode'), 'secret');

      verify(() => mockCubit.passwordChanged('secret')).called(1);
    });

    testWidgets('calls loginSubmitted when button is tapped', (tester) async {
      when(() => mockCubit.state).thenReturn(const LoginInitial(
        email: 'test@example.com',
        password: 'pass',
      ));
      when(() => mockCubit.loginSubmitted()).thenAnswer((_) async {});

      await tester.pumpWidget(buildSubject());
      await tester.tap(find.text('Log ind'));

      verify(() => mockCubit.loginSubmitted()).called(1);
    });

    testWidgets('calls rememberMeChanged when checkbox is toggled',
        (tester) async {
      when(() => mockCubit.state).thenReturn(const LoginInitial());
      when(() => mockCubit.rememberMeChanged(any())).thenReturn(null);

      await tester.pumpWidget(buildSubject());
      await tester.tap(find.byType(Checkbox));

      verify(() => mockCubit.rememberMeChanged(true)).called(1);
    });
  });
}
