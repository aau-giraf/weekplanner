import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/features/organisation_picker/data/repositories/organisation_repository.dart';
import 'package:weekplanner/features/organisation_picker/presentation/view_models/organisation_picker_view_model.dart';
import 'package:weekplanner/shared/models/citizen.dart';
import 'package:weekplanner/shared/models/grade.dart';
import 'package:weekplanner/shared/models/organisation.dart';

@GenerateNiceMocks([MockSpec<OrganisationRepository>()])
import 'organisation_picker_view_model_test.mocks.dart';

void main() {
  late MockOrganisationRepository mockRepo;
  late OrganisationPickerViewModel vm;

  final testOrgs = [
    const Organisation(id: 1, name: 'Org A'),
    const Organisation(id: 2, name: 'Org B'),
  ];

  final testCitizens = [
    const Citizen(id: 10, firstName: 'Alice', lastName: 'Hansen'),
  ];

  final testGrades = [
    const Grade(id: 20, name: 'Gruppe 1'),
  ];

  setUp(() {
    mockRepo = MockOrganisationRepository();
    when(mockRepo.organisations).thenReturn([]);
    when(mockRepo.citizens).thenReturn([]);
    when(mockRepo.grades).thenReturn([]);
    when(mockRepo.isLoading).thenReturn(false);
    when(mockRepo.error).thenReturn(null);
    vm = OrganisationPickerViewModel(repository: mockRepo);
  });

  group('OrganisationPickerViewModel', () {
    test('loadOrganisations delegates to repository', () async {
      when(mockRepo.fetchOrganisations()).thenAnswer((_) async {});

      await vm.loadOrganisations();
      verify(mockRepo.fetchOrganisations()).called(1);
    });

    test('selectOrganisation sets selected org and fetches citizens', () async {
      when(mockRepo.fetchCitizensAndGrades(1)).thenAnswer((_) async {});

      await vm.selectOrganisation(testOrgs[0]);
      expect(vm.selectedOrganisation, testOrgs[0]);
      verify(mockRepo.fetchCitizensAndGrades(1)).called(1);
    });

    test('exposes organisations from repository', () {
      when(mockRepo.organisations).thenReturn(testOrgs);
      expect(vm.organisations, testOrgs);
    });

    test('exposes citizens from repository', () {
      when(mockRepo.citizens).thenReturn(testCitizens);
      expect(vm.citizens, testCitizens);
    });

    test('exposes grades from repository', () {
      when(mockRepo.grades).thenReturn(testGrades);
      expect(vm.grades, testGrades);
    });

    test('exposes loading state from repository', () {
      when(mockRepo.isLoading).thenReturn(true);
      expect(vm.isLoading, true);
    });

    test('exposes error from repository', () {
      when(mockRepo.error).thenReturn('Some error');
      expect(vm.error, 'Some error');
    });
  });
}
