enum RoleType {
  owner(1000),
  admin(900),
  manager(800),
  staff(700),
  user(600),
  anonymous(500),
  undefined(0);

  final int power;

  const RoleType(this.power);

  factory RoleType.fromString(String? value) {
    switch (value?.toLowerCase().replaceAll(" ", "")) {
      case 'owner':
        return RoleType.owner;
      case 'admin':
        return RoleType.admin;
      case 'manager':
        return RoleType.manager;
      case 'staff':
        return RoleType.staff;
      case 'user':
        return RoleType.user;
      case 'anonymous':
        return RoleType.anonymous;

      default:
        return RoleType.undefined;
    }
  }

  String get label {
    switch (this) {
      case RoleType.owner:
        return 'Owner';
      case RoleType.admin:
        return 'Admin';
      case RoleType.manager:
        return 'Manager';
      case RoleType.staff:
        return 'Staff';
      case RoleType.user:
        return 'User';
      case RoleType.anonymous:
        return 'Anonymous';

      default:
        return 'Unknown';
    }
  }
}
