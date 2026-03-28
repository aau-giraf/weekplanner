import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weekplanner/core/errors/organisation_failure.dart';
import 'package:weekplanner/features/organisation_picker/domain/repositories/organisation_repository.dart';
import 'package:weekplanner/features/organisation_picker/domain/organisation_picker_state.dart';
import 'package:weekplanner/features/organisation_picker/presentation/organisation_picker_cubit.dart';
import 'package:weekplanner/shared/models/citizen.dart';
import 'package:weekplanner/shared/models/grade.dart';
import 'package:weekplanner/shared/models/organisation.dart';

class MockOrganisationRepository extends Mock
    implements OrganisationRepository {}

void main() {
  late MockOrganisationRepository mockRepo;

  const testOrgs = [
    Organisation(id: 1, name: 'Org A'),
    Organisation(id: 2, name: 'Org B'),
  ];
  const testCitizens = [
    Citizen(id: 10, firstName: 'Alice', lastName: 'Hansen'),
  ];
  const testGrades = [Grade(id: 20, name: 'Gruppe 1')];

  setUp(() {
    mockRepo = MockOrganisationRepository();
  });

  OrganisationPickerCubit buildCubit() =>
      OrganisationPickerCubit(repository: mockRepo);

  group('initial state', () {
    test('is OrganisationPickerInitial', () {
      final cubit = buildCubit();
      expect(cubit.state, const OrganisationPickerInitial());
      cubit.close();
    });
  });

  group('loadOrganisations', () {
    blocTest<OrganisationPickerCubit, OrganisationPickerState>(
      'emits [OrganisationsLoading, OrganisationsLoaded] on success',
      setUp: () {
        when(() => mockRepo.fetchOrganisations())
            .thenAnswer((_) async => const Right(testOrgs));
      },
      build: buildCubit,
      act: (cubit) => cubit.loadOrganisations(),
      expect: () => [
        const OrganisationsLoading(),
        const OrganisationsLoaded(organisations: testOrgs),
      ],
    );

    blocTest<OrganisationPickerCubit, OrganisationPickerState>(
      'emits [OrganisationsLoading, OrganisationPickerError] on failure',
      setUp: () {
        when(() => mockRepo.fetchOrganisations())
            .thenAnswer((_) async => const Left(FetchOrganisationsFailure()));
      },
      build: buildCubit,
      act: (cubit) => cubit.loadOrganisations(),
      expect: () => [
        const OrganisationsLoading(),
        const OrganisationPickerError(
          message: 'Kunne ikke hente organisationer',
        ),
      ],
    );

    blocTest<OrganisationPickerCubit, OrganisationPickerState>(
      'skips when already in OrganisationsLoading state',
      setUp: () {
        when(() => mockRepo.fetchOrganisations())
            .thenAnswer((_) async => const Right(testOrgs));
      },
      build: buildCubit,
      seed: () => const OrganisationsLoading(),
      act: (cubit) => cubit.loadOrganisations(),
      expect: () => <OrganisationPickerState>[],
      verify: (_) {
        verifyNever(() => mockRepo.fetchOrganisations());
      },
    );
  });

  group('selectOrganisation', () {
    blocTest<OrganisationPickerCubit, OrganisationPickerState>(
      'emits [CitizensLoading, CitizensLoaded] on success',
      setUp: () {
        when(() => mockRepo.fetchCitizensAndGrades(1)).thenAnswer(
          (_) async =>
              const Right((citizens: testCitizens, grades: testGrades)),
        );
      },
      build: buildCubit,
      seed: () => const OrganisationsLoaded(organisations: testOrgs),
      act: (cubit) => cubit.selectOrganisation(testOrgs.first),
      expect: () => [
        CitizensLoading(
          organisations: testOrgs,
          selectedOrganisation: testOrgs.first,
        ),
        CitizensLoaded(
          organisations: testOrgs,
          selectedOrganisation: testOrgs.first,
          citizens: testCitizens,
          grades: testGrades,
        ),
      ],
    );

    blocTest<OrganisationPickerCubit, OrganisationPickerState>(
      'emits [CitizensLoading, OrganisationPickerError] on failure '
      'and preserves organisations',
      setUp: () {
        when(() => mockRepo.fetchCitizensAndGrades(1))
            .thenAnswer((_) async => const Left(FetchCitizensFailure()));
      },
      build: buildCubit,
      seed: () => const OrganisationsLoaded(organisations: testOrgs),
      act: (cubit) => cubit.selectOrganisation(testOrgs.first),
      expect: () => [
        CitizensLoading(
          organisations: testOrgs,
          selectedOrganisation: testOrgs.first,
        ),
        const OrganisationPickerError(
          message: 'Kunne ikke hente borgere',
          organisations: testOrgs,
        ),
      ],
    );
  });

  group('selectOrganisationById', () {
    blocTest<OrganisationPickerCubit, OrganisationPickerState>(
      'loads organisations first if state has no orgs, then selects',
      setUp: () {
        when(() => mockRepo.fetchOrganisations())
            .thenAnswer((_) async => const Right(testOrgs));
        when(() => mockRepo.fetchCitizensAndGrades(1)).thenAnswer(
          (_) async =>
              const Right((citizens: testCitizens, grades: testGrades)),
        );
      },
      build: buildCubit,
      act: (cubit) => cubit.selectOrganisationById(1),
      expect: () => [
        const OrganisationsLoading(),
        const OrganisationsLoaded(organisations: testOrgs),
        CitizensLoading(
          organisations: testOrgs,
          selectedOrganisation: testOrgs.first,
        ),
        CitizensLoaded(
          organisations: testOrgs,
          selectedOrganisation: testOrgs.first,
          citizens: testCitizens,
          grades: testGrades,
        ),
      ],
    );

    blocTest<OrganisationPickerCubit, OrganisationPickerState>(
      'does nothing for unknown id',
      build: buildCubit,
      seed: () => const OrganisationsLoaded(organisations: testOrgs),
      act: (cubit) => cubit.selectOrganisationById(999),
      expect: () => <OrganisationPickerState>[],
    );
  });
}
