import 'package:weekplanner/roles/roles.dart';

/// Concrete strategy for Superuser role
class SuperuserStrategy implements RoleStrategy<SuperuserStrategy> {
  @override
  void performRoleAction() {
    // Implement actions specific to Superuser role
    print("Performing actions as a Superuser");
  }
}