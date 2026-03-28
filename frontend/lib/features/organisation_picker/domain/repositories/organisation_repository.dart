import 'package:fpdart/fpdart.dart';

import 'package:weekplanner/core/errors/organisation_failure.dart';
import 'package:weekplanner/shared/models/citizen.dart';
import 'package:weekplanner/shared/models/grade.dart';
import 'package:weekplanner/shared/models/organisation.dart';

/// Contract for organisation data operations.
abstract class OrganisationRepository {
  Future<Either<OrganisationFailure, List<Organisation>>> fetchOrganisations();
  Future<
      Either<OrganisationFailure,
          ({List<Citizen> citizens, List<Grade> grades})>>
      fetchCitizensAndGrades(int orgId);
}
