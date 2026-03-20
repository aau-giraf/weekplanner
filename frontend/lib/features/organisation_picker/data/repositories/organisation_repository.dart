import 'package:flutter/foundation.dart';
import 'package:weekplanner/shared/models/citizen.dart';
import 'package:weekplanner/shared/models/grade.dart';
import 'package:weekplanner/shared/models/organisation.dart';
import 'package:weekplanner/shared/services/core_api_service.dart';

class OrganisationRepository extends ChangeNotifier {
  final CoreApiService _coreApiService;

  OrganisationRepository({required CoreApiService coreApiService})
      : _coreApiService = coreApiService;

  List<Organisation> _organisations = [];
  List<Citizen> _citizens = [];
  List<Grade> _grades = [];
  bool _isLoading = false;
  String? _error;

  List<Organisation> get organisations => _organisations;
  List<Citizen> get citizens => _citizens;
  List<Grade> get grades => _grades;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchOrganisations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _coreApiService.fetchOrganisations();
      _organisations = response.items;
    } catch (e) {
      _error = 'Kunne ikke hente organisationer';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCitizensAndGrades(int orgId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _coreApiService.fetchCitizens(orgId),
        _coreApiService.fetchGrades(orgId),
      ]);
      _citizens = results[0].items as List<Citizen>;
      _grades = results[1].items as List<Grade>;
    } catch (e) {
      _error = 'Kunne ikke hente borgere';
    }

    _isLoading = false;
    notifyListeners();
  }
}
