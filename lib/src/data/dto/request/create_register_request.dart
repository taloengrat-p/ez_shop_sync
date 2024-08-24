class CreateRegisterRequest {
  final String storeName;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String salt;
  CreateRegisterRequest({
    required this.storeName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.salt,
  });
}
