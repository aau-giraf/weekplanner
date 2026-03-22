import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/organisation_picker/domain/organisation_picker_state.dart';
import 'package:weekplanner/features/organisation_picker/presentation/organisation_picker_cubit.dart';
import 'package:weekplanner/features/organisation_picker/presentation/views/citizen_picker_view.dart';
import 'package:weekplanner/shared/models/citizen.dart';
import 'package:weekplanner/shared/models/grade.dart';
import 'package:weekplanner/shared/models/organisation.dart';

class MockOrganisationPickerCubit extends MockCubit<OrganisationPickerState>
    implements OrganisationPickerCubit {}

void main() {
  late MockOrganisationPickerCubit mockCubit;

  const testOrg = Organisation(id: 1, name: 'Org A');

  setUp(() {
    mockCubit = MockOrganisationPickerCubit();
  });

  Widget buildSubject() {
    return MaterialApp(
      theme: girafTheme,
      home: BlocProvider<OrganisationPickerCubit>.value(
        value: mockCubit,
        child: const CitizenPickerView(orgId: 1),
      ),
    );
  }

  group('CitizenPickerView', () {
    testWidgets('shows spinner when loading citizens', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const CitizensLoading(
          organisations: [testOrg],
          selectedOrganisation: testOrg,
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows citizen and grade names when loaded', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const CitizensLoaded(
          organisations: [testOrg],
          selectedOrganisation: testOrg,
          citizens: [
            Citizen(id: 10, firstName: 'Alice', lastName: 'Hansen'),
            Citizen(id: 11, firstName: 'Bob', lastName: 'Jensen'),
          ],
          grades: [
            Grade(id: 20, name: 'Gruppe 1'),
          ],
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('Alice Hansen'), findsOneWidget);
      expect(find.text('Bob Jensen'), findsOneWidget);
      expect(find.text('Gruppe 1'), findsOneWidget);
      expect(find.text('Borger'), findsNWidgets(2));
      expect(find.text('Gruppe'), findsOneWidget);
    });

    testWidgets('shows empty message when no citizens or grades',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const CitizensLoaded(
          organisations: [testOrg],
          selectedOrganisation: testOrg,
          citizens: [],
          grades: [],
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(
          find.text('Ingen borgere eller grupper fundet'), findsOneWidget);
    });

    testWidgets('shows error message on error state', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const OrganisationPickerError(
          message: 'Kunne ikke hente borgere',
          organisations: [testOrg],
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('Kunne ikke hente borgere'), findsOneWidget);
    });
  });
}
