import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:weekplanner/features/auth/domain/auth_state.dart';
import 'package:weekplanner/features/auth/presentation/auth_cubit.dart';
import 'package:weekplanner/features/organisation_picker/domain/organisation_picker_state.dart';
import 'package:weekplanner/features/organisation_picker/presentation/organisation_picker_cubit.dart';
import 'package:weekplanner/features/organisation_picker/presentation/views/organisation_picker_view.dart';
import 'package:weekplanner/shared/models/organisation.dart';

class MockOrganisationPickerCubit extends MockCubit<OrganisationPickerState>
    implements OrganisationPickerCubit {}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  late MockOrganisationPickerCubit mockPickerCubit;
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockPickerCubit = MockOrganisationPickerCubit();
    mockAuthCubit = MockAuthCubit();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<OrganisationPickerCubit>.value(value: mockPickerCubit),
          BlocProvider<AuthCubit>.value(value: mockAuthCubit),
        ],
        child: const OrganisationPickerView(),
      ),
    );
  }

  group('OrganisationPickerView', () {
    testWidgets('shows spinner in initial state', (tester) async {
      when(() => mockPickerCubit.state)
          .thenReturn(const OrganisationPickerInitial());

      await tester.pumpWidget(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows spinner in loading state', (tester) async {
      when(() => mockPickerCubit.state)
          .thenReturn(const OrganisationsLoading());

      await tester.pumpWidget(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows organisation list when loaded', (tester) async {
      when(() => mockPickerCubit.state).thenReturn(
        const OrganisationsLoaded(organisations: [
          Organisation(id: 1, name: 'Org A'),
          Organisation(id: 2, name: 'Org B'),
        ]),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('Org A'), findsOneWidget);
      expect(find.text('Org B'), findsOneWidget);
    });

    testWidgets('shows empty message when no organisations', (tester) async {
      when(() => mockPickerCubit.state).thenReturn(
        const OrganisationsLoaded(organisations: []),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('Ingen organisationer fundet'), findsOneWidget);
    });

    testWidgets('shows error text and retry button when error with no orgs',
        (tester) async {
      when(() => mockPickerCubit.state).thenReturn(
        const OrganisationPickerError(message: 'Netværksfejl'),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('Netværksfejl'), findsOneWidget);
      expect(find.text('Prøv igen'), findsOneWidget);
    });

    testWidgets('tapping retry calls loadOrganisations', (tester) async {
      when(() => mockPickerCubit.state).thenReturn(
        const OrganisationPickerError(message: 'Fejl'),
      );
      when(() => mockPickerCubit.loadOrganisations())
          .thenAnswer((_) async {});

      await tester.pumpWidget(buildSubject());
      await tester.tap(find.text('Prøv igen'));

      verify(() => mockPickerCubit.loadOrganisations()).called(1);
    });

    testWidgets('tapping logout calls authCubit.logout', (tester) async {
      when(() => mockPickerCubit.state)
          .thenReturn(const OrganisationPickerInitial());
      when(() => mockAuthCubit.logout()).thenAnswer((_) async {});

      await tester.pumpWidget(buildSubject());
      await tester.tap(find.byIcon(Icons.logout));

      verify(() => mockAuthCubit.logout()).called(1);
    });
  });
}
