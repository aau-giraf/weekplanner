import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';

import 'package:weekplanner/features/organisation_picker/data/repositories/organisation_repository.dart';
import 'package:weekplanner/features/organisation_picker/domain/organisation_picker_state.dart';
import 'package:weekplanner/shared/models/organisation.dart';

final _log = Logger('OrganisationPickerCubit');

/// Manages state for the organisation-and-citizen picker flow.
///
/// Loads organisations, then citizens and grades for a selected organisation.
class OrganisationPickerCubit extends Cubit<OrganisationPickerState> {
  final OrganisationRepository _repository;

  OrganisationPickerCubit({required OrganisationRepository repository})
      : _repository = repository,
        super(const OrganisationPickerInitial());

  /// Organisations extracted from any state that carries them.
  List<Organisation> get _currentOrganisations => switch (state) {
        OrganisationsLoaded(:final organisations) => organisations,
        CitizensLoading(:final organisations) => organisations,
        CitizensLoaded(:final organisations) => organisations,
        OrganisationPickerError(:final organisations) => organisations,
        _ => const [],
      };

  /// Fetch all organisations the user belongs to.
  ///
  /// Skips the call if already in a loading state.
  Future<void> loadOrganisations() async {
    if (state is OrganisationsLoading) return;

    emit(const OrganisationsLoading());

    final result = await _repository.fetchOrganisations();
    switch (result) {
      case Left(:final value):
        emit(OrganisationPickerError(message: value.message));
      case Right(:final value):
        emit(OrganisationsLoaded(organisations: value));
    }
  }

  /// Select an organisation and fetch its citizens and grades.
  Future<void> selectOrganisation(Organisation org) async {
    final orgs = _currentOrganisations;

    emit(CitizensLoading(organisations: orgs, selectedOrganisation: org));

    final result = await _repository.fetchCitizensAndGrades(org.id);
    switch (result) {
      case Left(:final value):
        emit(OrganisationPickerError(
          message: value.message,
          organisations: orgs,
        ));
      case Right(:final value):
        emit(CitizensLoaded(
          organisations: orgs,
          selectedOrganisation: org,
          citizens: value.citizens,
          grades: value.grades,
        ));
    }
  }

  /// Select an organisation by its ID.
  ///
  /// If no organisations are loaded yet, loads them first. Does nothing if
  /// the given [orgId] is not found among the loaded organisations.
  Future<void> selectOrganisationById(int orgId) async {
    var orgs = _currentOrganisations;

    if (orgs.isEmpty) {
      await loadOrganisations();
      orgs = _currentOrganisations;
    }

    final org = orgs.where((o) => o.id == orgId).firstOrNull;
    if (org == null) {
      _log.warning('Organisation $orgId not found');
      return;
    }

    await selectOrganisation(org);
  }
}
