class CreateRegisterRequest {
  final String storeName;
  final String firstName;
  final String lastName;
  final String email;

  CreateRegisterRequest({
    required this.storeName,
    required this.firstName,
    required this.lastName,
    required this.email,
  });
}
