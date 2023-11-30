// Define a strategy interface
abstract class RoleStrategy {
  void performRoleAction();
}

// Concrete strategy for Citizen role
class CitizenStrategy implements RoleStrategy {
  @override
  void performRoleAction() {
    // Implement actions specific to Citizen role
    print("Performing actions as a Citizen");
  }
}

// Concrete strategy for Trustee role
class TrusteeStrategy implements RoleStrategy {
  @override
  void performRoleAction() {
    // Implement actions specific to Trustee role
    print("Performing actions as a Trustee");
  }
}

// Concrete strategy for Guardian role
class GuardianStrategy implements RoleStrategy {
  @override
  void performRoleAction() {
    // Implement actions specific to Guardian role
    print("Performing actions as a Guardian");
  }
}

// Concrete strategy for Superuser role
class SuperuserStrategy implements RoleStrategy {
  @override
  void performRoleAction() {
    // Implement actions specific to Superuser role
    print("Performing actions as a Superuser");
  }
}
// Context class that uses the strategy
class UserContext {
  RoleStrategy _roleStrategy;

  UserContext(this._roleStrategy);

  void setRoleStrategy(RoleStrategy strategy) {
    _roleStrategy = strategy;
  }

  void executeRoleAction() {
    _roleStrategy.performRoleAction();
  }
}