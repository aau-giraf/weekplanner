/// Define a strategy interface
abstract class RoleStrategy<T> {
  void performRoleAction();
}









/// Context class that uses the strategy
class UserContext<T extends RoleStrategy<T>> {
  RoleStrategy<T> _roleStrategy;

  UserContext(this._roleStrategy);

  void setRoleStrategy(RoleStrategy<T> strategy) {
    _roleStrategy = strategy;
  }

  void executeRoleAction() {
    _roleStrategy.performRoleAction();
  }
}






