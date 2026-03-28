import 'package:fpdart/fpdart.dart';

import 'package:weekplanner/core/errors/organisation_failure.dart';
import 'package:weekplanner/shared/models/citizen.dart';
import 'package:weekplanner/shared/models/grade.dart';
import 'package:weekplanner/shared/models/organisation.dart';

/// Contract for organisation data operations.
abstract interface class OrganisationRepository {
  /// Fetch all organisations the current user belongs to.
  Future<Either<OrganisationFailure, List<Organisation>>> fetchOrganisations();

  /// Fetch citizens and grades for a given organisation.
  Future<
      Either<OrganisationFailure,
          ({List<Citizen> citizens, List<Grade> grades})>>
      fetchCitizensAndGrades(int orgId);
}
