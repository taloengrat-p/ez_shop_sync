enum RoleType {
  owner,
  admin,
  manager,
  staff,
  user,
  anonymous,
  undefined;

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
}
