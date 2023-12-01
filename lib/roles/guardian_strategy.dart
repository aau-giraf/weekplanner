import 'package:weekplanner/roles/roles.dart';

/// Concrete strategy for Guardian role
class GuardianStrategy implements RoleStrategy<GuardianStrategy> {
  @override
  void performRoleAction() {
    // Implement actions specific to Guardian role
    print("Performing actions as a Guardian");
  }
}