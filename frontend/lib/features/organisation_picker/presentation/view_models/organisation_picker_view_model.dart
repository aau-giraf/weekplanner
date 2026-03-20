import 'package:flutter/foundation.dart';
import 'package:weekplanner/features/organisation_picker/data/repositories/organisation_repository.dart';
import 'package:weekplanner/shared/models/citizen.dart';
import 'package:weekplanner/shared/models/grade.dart';
import 'package:weekplanner/shared/models/organisation.dart';

class OrganisationPickerViewModel extends ChangeNotifier {
  final OrganisationRepository _repository;

  OrganisationPickerViewModel({required OrganisationRepository repository})
      : _repository = repository;

  Organisation? _selectedOrganisation;

  Organisation? get selectedOrganisation => _selectedOrganisation;
  List<Organisation> get organisations => _repository.organisations;
  List<Citizen> get citizens => _repository.citizens;
  List<Grade> get grades => _repository.grades;
  bool get isLoading => _repository.isLoading;
  String? get error => _repository.error;

  Future<void> loadOrganisations() async {
    await _repository.fetchOrganisations();
    notifyListeners();
  }

  Future<void> selectOrganisation(Organisation org) async {
    _selectedOrganisation = org;
    notifyListeners();
    await _repository.fetchCitizensAndGrades(org.id);
    notifyListeners();
  }
}
