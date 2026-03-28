import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';

import 'package:weekplanner/core/errors/organisation_failure.dart';
import 'package:weekplanner/features/organisation_picker/domain/repositories/organisation_repository.dart';
import 'package:weekplanner/shared/models/citizen.dart';
import 'package:weekplanner/shared/models/grade.dart';
import 'package:weekplanner/shared/models/organisation.dart';
import 'package:weekplanner/shared/services/core_api_service.dart';

final _log = Logger('OrganisationRepository');

/// Pure data layer for organisation operations.
///
/// All methods return [Either] to communicate success or typed failure.
/// No state management — that responsibility belongs to the ViewModel/Cubit.
class OrganisationRepositoryImpl implements OrganisationRepository {
  final CoreApiService _coreApiService;

  OrganisationRepositoryImpl({required CoreApiService coreApiService})
      : _coreApiService = coreApiService;

  @override
  Future<Either<OrganisationFailure, List<Organisation>>>
      fetchOrganisations() async {
    try {
      final response = await _coreApiService.fetchOrganisations();
      return Right(response.items);
    } catch (e, stackTrace) {
      _log.severe('Failed to fetch organisations', e, stackTrace);
      return Left(const FetchOrganisationsFailure());
    }
  }

  @override
  Future<
      Either<OrganisationFailure,
          ({List<Citizen> citizens, List<Grade> grades})>>
      fetchCitizensAndGrades(int orgId) async {
    try {
      final citizenResponse = await _coreApiService.fetchCitizens(orgId);
      final gradeResponse = await _coreApiService.fetchGrades(orgId);
      return Right(
        (citizens: citizenResponse.items, grades: gradeResponse.items),
      );
    } catch (e, stackTrace) {
      _log.severe('Failed to fetch citizens and grades', e, stackTrace);
      return Left(const FetchCitizensFailure());
    }
  }
}
