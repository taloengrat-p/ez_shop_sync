import 'package:hive_flutter/hive_flutter.dart';

part 'role_type.enum.g.dart';

@HiveType(typeId: 23)
enum RoleType {
  @HiveField(0)
  owner(1000),
  @HiveField(1)
  admin(900),
  @HiveField(2)
  manager(800),
  @HiveField(3)
  staff(700),
  @HiveField(4)
  user(600),
  @HiveField(5)
  anonymous(500),
  @HiveField(6)
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
