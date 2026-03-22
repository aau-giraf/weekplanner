import 'package:equatable/equatable.dart';

import 'package:weekplanner/shared/models/citizen.dart';
import 'package:weekplanner/shared/models/grade.dart';
import 'package:weekplanner/shared/models/organisation.dart';

/// State managed by [OrganisationPickerCubit].
sealed class OrganisationPickerState extends Equatable {
  const OrganisationPickerState();
}

/// Nothing has been loaded yet.
final class OrganisationPickerInitial extends OrganisationPickerState {
  const OrganisationPickerInitial();

  @override
  List<Object?> get props => [];
}

/// Fetching the list of organisations.
final class OrganisationsLoading extends OrganisationPickerState {
  const OrganisationsLoading();

  @override
  List<Object?> get props => [];
}

/// Organisation list is ready for display.
final class OrganisationsLoaded extends OrganisationPickerState {
  /// The available organisations.
  final List<Organisation> organisations;

  const OrganisationsLoaded({required this.organisations});

  @override
  List<Object?> get props => [organisations];
}

/// Fetching citizens and grades for the selected organisation.
final class CitizensLoading extends OrganisationPickerState {
  /// All loaded organisations (kept so the UI can render context).
  final List<Organisation> organisations;

  /// The organisation whose citizens are being fetched.
  final Organisation selectedOrganisation;

  const CitizensLoading({
    required this.organisations,
    required this.selectedOrganisation,
  });

  @override
  List<Object?> get props => [organisations, selectedOrganisation];
}

/// Citizens and grades are ready — the user can pick.
final class CitizensLoaded extends OrganisationPickerState {
  /// All loaded organisations.
  final List<Organisation> organisations;

  /// The organisation whose data is shown.
  final Organisation selectedOrganisation;

  /// Citizens belonging to the selected organisation.
  final List<Citizen> citizens;

  /// Grades belonging to the selected organisation.
  final List<Grade> grades;

  const CitizensLoaded({
    required this.organisations,
    required this.selectedOrganisation,
    required this.citizens,
    required this.grades,
  });

  @override
  List<Object?> get props => [
        organisations,
        selectedOrganisation,
        citizens,
        grades,
      ];
}

/// An error occurred; previously-loaded organisations are preserved for retry.
final class OrganisationPickerError extends OrganisationPickerState {
  /// Human-readable error message.
  final String message;

  /// Organisations loaded before the error, or empty if none were loaded.
  final List<Organisation> organisations;

  const OrganisationPickerError({
    required this.message,
    this.organisations = const [],
  });

  @override
  List<Object?> get props => [message, organisations];
}
