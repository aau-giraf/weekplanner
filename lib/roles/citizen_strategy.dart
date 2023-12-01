import 'package:weekplanner/roles/roles.dart';

/// Concrete strategy for Citizen role
class CitizenStrategy implements RoleStrategy<CitizenStrategy> {
  @override
  void performRoleAction() {
    // Implement actions specific to Citizen role
    print("Performing actions as a Citizen");
  }
}