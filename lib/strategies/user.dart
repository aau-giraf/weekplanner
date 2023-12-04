import 'super_user_strategy.dart';
import 'guardian_strategy.dart';
import 'trustee_strategy.dart';
import 'Role_strategy.dart';
import 'citizen_strategy.dart';
import 'role.dart';


class User {
  User(Role? role) {
    RoleStrategy roleStrategy;

    if (role == null) {
      throw ArgumentError('Role cannot be null');
    }

    switch (role) {
      case Role.SuperUser:
        roleStrategy = SuperUserStrategy();
        roleStrategy.UselessPrint();
        break;
      case Role.Guardian:
        roleStrategy = GuardianStrategy();
        roleStrategy.UselessPrint();
        break;
      case Role.Trustee:
        roleStrategy = TrusteeStrategy();
        roleStrategy.UselessPrint();
        break;
      case Role.Citizen:
        roleStrategy = CitizenStrategy();
        roleStrategy.UselessPrint();
        break;
      default:
        throw ArgumentError('Invalid role provided: $role');
    }
  }
}