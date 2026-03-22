import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/domain/activity_form_state.dart';
import 'package:weekplanner/features/weekplan/presentation/activity_form_cubit.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/pictogram_selector.dart';
import 'package:weekplanner/shared/models/pictogram.dart';

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
      home: Scaffold(
        body: BlocProvider<ActivityFormCubit>.value(
          value: mockCubit,
          child: const PictogramSelector(),
        ),
      ),
    );
  }

  group('PictogramSelector', () {
    testWidgets('renders 3 mode segments', (tester) async {
      when(() => mockCubit.state).thenReturn(ActivityFormReady(
        date: testDate,
      ));

      await tester.pumpWidget(buildSubject());

      expect(find.text('Søg'), findsOneWidget);
      expect(find.text('Upload'), findsOneWidget);
      expect(find.text('Generer'), findsOneWidget);
    });

    testWidgets('search mode shows search field', (tester) async {
      when(() => mockCubit.state).thenReturn(ActivityFormReady(
        date: testDate,
        pictogramMode: PictogramMode.search,
      ));

      await tester.pumpWidget(buildSubject());

      expect(
        find.widgetWithText(TextField, 'Søg piktogrammer...'),
        findsOneWidget,
      );
    });

    testWidgets('search mode shows loading indicator when searching',
        (tester) async {
      when(() => mockCubit.state).thenReturn(ActivityFormReady(
        date: testDate,
        pictogramMode: PictogramMode.search,
        isSearching: true,
      ));

      await tester.pumpWidget(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('search mode shows pictogram grid with results',
        (tester) async {
      const pictogram = Pictogram(id: 1, name: 'test');
      when(() => mockCubit.state).thenReturn(ActivityFormReady(
        date: testDate,
        pictogramMode: PictogramMode.search,
        searchResults: [pictogram],
      ));

      await tester.pumpWidget(buildSubject());

      expect(find.byType(GridView), findsOneWidget);
      expect(find.text('test'), findsOneWidget);
    });

    testWidgets('upload mode shows name field and image button', (tester) async {
      when(() => mockCubit.state).thenReturn(ActivityFormReady(
        date: testDate,
        pictogramMode: PictogramMode.upload,
      ));

      await tester.pumpWidget(buildSubject());

      expect(find.text('Navn'), findsOneWidget);
      expect(find.text('Vælg billede'), findsOneWidget);
    });

    testWidgets('generate mode shows name field and prompt field',
        (tester) async {
      when(() => mockCubit.state).thenReturn(ActivityFormReady(
        date: testDate,
        pictogramMode: PictogramMode.generate,
      ));

      await tester.pumpWidget(buildSubject());

      expect(find.text('Beskrivelse til AI (valgfrit)'), findsOneWidget);
    });

    testWidgets('shows selected pictogram preview with name and check icon',
        (tester) async {
      const pictogram = Pictogram(id: 1, name: 'Sol');
      when(() => mockCubit.state).thenReturn(ActivityFormReady(
        date: testDate,
        selectedPictogram: pictogram,
        selectedPictogramId: 1,
      ));

      await tester.pumpWidget(buildSubject());

      expect(find.text('Sol'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows no preview when no pictogram is selected',
        (tester) async {
      when(() => mockCubit.state).thenReturn(ActivityFormReady(
        date: testDate,
      ));

      await tester.pumpWidget(buildSubject());

      expect(find.byIcon(Icons.check_circle), findsNothing);
    });
  });
}
