import 'package:hive/hive.dart';

import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';

part 'user.g.dart';

@HiveType(typeId: 4)
class User extends BaseHiveObject {
  @HiveField(6, defaultValue: [])
  List<String>? storeId;

  @HiveField(7)
  String firstName;

  @HiveField(8)
  String lastName;

  @HiveField(9, defaultValue: null)
  String? phoneNumber;

  @HiveField(10)
  String email;

  @HiveField(11)
  String username;

  @HiveField(12, defaultValue: null)
  String? profilePictureUrl;

  @HiveField(13, defaultValue: null)
  String? storeLatest;

  String get fullname => '$firstName $lastName';

  User({
    required super.id,
    super.createDate,
    super.createBy,
    super.updateDate,
    super.updateBy,
    required this.storeId,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.email,
    required this.username,
    this.profilePictureUrl,
    this.storeLatest,
  });

  @override
  String toString() {
    return 'User(storeId: $storeId, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, email: $email, username: $username, profilePictureUrl: $profilePictureUrl, storeLatest: $storeLatest)';
  }
}
