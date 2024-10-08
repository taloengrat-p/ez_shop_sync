class CreateRegisterRequest {
  final String storeName;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String storeDesc;

  CreateRegisterRequest({
    required this.storeName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.storeDesc,
  });
}
