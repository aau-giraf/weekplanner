import 'package:weekplanner/roles/roles.dart';


/// Concrete strategy for Trustee role
class TrusteeStrategy implements RoleStrategy<TrusteeStrategy> {
  @override
  void performRoleAction() {
    // Implement actions specific to Trustee role
    print("Performing actions as a Trustee");
  }
}