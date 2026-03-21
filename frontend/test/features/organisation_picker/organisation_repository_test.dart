import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/features/organisation_picker/data/repositories/organisation_repository.dart';
import 'package:weekplanner/shared/models/citizen.dart';
import 'package:weekplanner/shared/models/grade.dart';
import 'package:weekplanner/shared/models/organisation.dart';
import 'package:weekplanner/shared/models/paginated_response.dart';
import 'package:weekplanner/shared/services/core_api_service.dart';

class FakeCoreApiService extends CoreApiService {
  Future<PaginatedResponse<Organisation>> Function()? onFetchOrganisations;
  Future<PaginatedResponse<Citizen>> Function(int orgId)? onFetchCitizens;
  Future<PaginatedResponse<Grade>> Function(int orgId)? onFetchGrades;

  @override
  Future<PaginatedResponse<Organisation>> fetchOrganisations() async {
    if (onFetchOrganisations == null) {
      throw UnimplementedError('onFetchOrganisations not configured');
    }
    return onFetchOrganisations!();
  }

  @override
  Future<PaginatedResponse<Citizen>> fetchCitizens(int orgId) async {
    if (onFetchCitizens == null) {
      throw UnimplementedError('onFetchCitizens not configured');
    }
    return onFetchCitizens!(orgId);
  }

  @override
  Future<PaginatedResponse<Grade>> fetchGrades(int orgId) async {
    if (onFetchGrades == null) {
      throw UnimplementedError('onFetchGrades not configured');
    }
    return onFetchGrades!(orgId);
  }
}

void main() {
  late FakeCoreApiService fakeCore;
  late OrganisationRepository repo;

  const org = Organisation(id: 1, name: 'Org A');
  const citizen = Citizen(id: 10, firstName: 'Alice', lastName: 'Hansen');
  const grade = Grade(id: 20, name: 'Gruppe 1');

  setUp(() {
    fakeCore = FakeCoreApiService();
    repo = OrganisationRepository(coreApiService: fakeCore);
  });

  group('OrganisationRepository', () {
    test('fetchOrganisations stores list on success', () async {
      fakeCore.onFetchOrganisations = () async => const PaginatedResponse(
            items: [org],
            count: 1,
          );

      await repo.fetchOrganisations();

      expect(repo.organisations, [org]);
      expect(repo.error, isNull);
      expect(repo.isLoading, isFalse);
    });

    test('fetchOrganisations sets error on failure', () async {
      fakeCore.onFetchOrganisations = () async => throw Exception('boom');

      await repo.fetchOrganisations();

      expect(repo.error, isNotNull);
      expect(repo.isLoading, isFalse);
    });

    test('fetchCitizensAndGrades stores both lists', () async {
      fakeCore.onFetchCitizens = (_) async => const PaginatedResponse(
            items: [citizen],
            count: 1,
          );
      fakeCore.onFetchGrades = (_) async => const PaginatedResponse(
            items: [grade],
            count: 1,
          );

      await repo.fetchCitizensAndGrades(1);

      expect(repo.citizens, [citizen]);
      expect(repo.grades, [grade]);
      expect(repo.error, isNull);
      expect(repo.isLoading, isFalse);
    });
  });
}
