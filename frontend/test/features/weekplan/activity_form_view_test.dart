import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/domain/activity_form_state.dart';
import 'package:weekplanner/features/weekplan/presentation/activity_form_cubit.dart';
import 'package:weekplanner/features/weekplan/presentation/views/activity_form_view.dart';

class MockActivityFormCubit extends MockCubit<ActivityFormState>
    implements ActivityFormCubit {}

void main() {
  late MockActivityFormCubit mockCubit;

  final testDate = DateTime(2026, 3, 22);

  setUp(() {
    mockCubit = MockActivityFormCubit();
  });

  Widget buildSubject() {
    return MaterialApp(
      theme: girafTheme,
      home: BlocProvider<ActivityFormCubit>.value(
        value: mockCubit,
        child: const ActivityFormView(
          title: 'Tilføj aktivitet',
          submitLabel: 'Tilføj',
        ),
      ),
    );
  }

  group('ActivityFormView', () {
    testWidgets('shows time pickers and submit button in ready state',
        (tester) async {
      when(() => mockCubit.state).thenReturn(ActivityFormReady(
        form: ActivityFormData(date: testDate),
      ));

      await tester.pumpWidget(buildSubject());

      expect(find.text('Starttid'), findsOneWidget);
      expect(find.text('Sluttid'), findsOneWidget);
      expect(find.text('Tilføj'), findsOneWidget);
    });

    testWidgets('shows error text in ready state with error', (tester) async {
      when(() => mockCubit.state).thenReturn(ActivityFormReady(
        form: ActivityFormData(date: testDate),
        error: 'Sluttid skal være efter starttid',
      ));

      await tester.pumpWidget(buildSubject());

      expect(find.text('Sluttid skal være efter starttid'), findsOneWidget);
    });

    testWidgets('disables submit button and shows spinner in saving state',
        (tester) async {
      when(() => mockCubit.state).thenReturn(ActivityFormSaving(
        form: ActivityFormData(date: testDate),
      ));

      await tester.pumpWidget(buildSubject());

      // Spinner is shown instead of submit label
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      expect(find.text('Tilføj'), findsNothing);

      // The ElevatedButton should be disabled
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton).first);
      expect(button.onPressed, isNull);
    });

    testWidgets('tapping submit calls save', (tester) async {
      when(() => mockCubit.state).thenReturn(ActivityFormReady(
        form: ActivityFormData(date: testDate),
      ));
      when(() => mockCubit.save()).thenAnswer((_) async => true);

      await tester.pumpWidget(buildSubject());
      await tester.tap(find.text('Tilføj'));

      verify(() => mockCubit.save()).called(1);
    });
  });
}
