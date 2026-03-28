import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weekplanner/core/errors/organisation_failure.dart';
import 'package:weekplanner/features/organisation_picker/data/repositories/organisation_repository.dart';
import 'package:weekplanner/features/organisation_picker/domain/repositories/organisation_repository.dart';
import 'package:weekplanner/shared/models/citizen.dart';
import 'package:weekplanner/shared/models/grade.dart';
import 'package:weekplanner/shared/models/organisation.dart';
import 'package:weekplanner/shared/models/paginated_response.dart';
import 'package:weekplanner/shared/services/organisation_api_service.dart';

class MockOrganisationApiService extends Mock
    implements OrganisationApiService {}

void main() {
  late MockOrganisationApiService mockCore;
  late OrganisationRepository repo;

  const org = Organisation(id: 1, name: 'Org A');
  const citizen = Citizen(id: 10, firstName: 'Alice', lastName: 'Hansen');
  const grade = Grade(id: 20, name: 'Gruppe 1');

  setUp(() {
    mockCore = MockOrganisationApiService();
    repo = OrganisationRepositoryImpl(apiService: mockCore);
  });

  group('fetchOrganisations', () {
    test('returns Right with organisation list on success', () async {
      when(() => mockCore.fetchOrganisations()).thenAnswer(
        (_) async => const PaginatedResponse(items: [org], count: 1),
      );

      final result = await repo.fetchOrganisations();

      expect(result, isA<Right<OrganisationFailure, List<Organisation>>>());
      expect(result.getOrElse((_) => []), [org]);
      verify(() => mockCore.fetchOrganisations()).called(1);
    });

    test('returns Left(FetchOrganisationsFailure) on exception', () async {
      when(() => mockCore.fetchOrganisations())
          .thenThrow(Exception('network error'));

      final result = await repo.fetchOrganisations();

      expect(result, isA<Left<OrganisationFailure, List<Organisation>>>());
      result.fold(
        (failure) => expect(failure, isA<FetchOrganisationsFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('fetchCitizensAndGrades', () {
    test('returns Right with citizens and grades record on success', () async {
      when(() => mockCore.fetchCitizens(1)).thenAnswer(
        (_) async => const PaginatedResponse(items: [citizen], count: 1),
      );
      when(() => mockCore.fetchGrades(1)).thenAnswer(
        (_) async => const PaginatedResponse(items: [grade], count: 1),
      );

      final result = await repo.fetchCitizensAndGrades(1);

      result.fold(
        (_) => fail('Expected Right'),
        (data) {
          expect(data.citizens, [citizen]);
          expect(data.grades, [grade]);
        },
      );
      verify(() => mockCore.fetchCitizens(1)).called(1);
      verify(() => mockCore.fetchGrades(1)).called(1);
    });

    test('returns Left(FetchCitizensFailure) on exception', () async {
      when(() => mockCore.fetchCitizens(1))
          .thenThrow(Exception('network error'));
      when(() => mockCore.fetchGrades(1)).thenAnswer(
        (_) async => const PaginatedResponse(items: [grade], count: 1),
      );

      final result = await repo.fetchCitizensAndGrades(1);

      result.fold(
        (failure) => expect(failure, isA<FetchCitizensFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
