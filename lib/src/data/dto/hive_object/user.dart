import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 4)
class User extends BaseHiveObject {
  @HiveField(7, defaultValue: [])
  List<String>? storeId;

  @HiveField(8)
  String firstName;

  @HiveField(9)
  String lastName;

  @HiveField(10, defaultValue: null)
  String? phoneNumber;

  @HiveField(11)
  String email;

  @HiveField(12)
  String username;

  @HiveField(13, defaultValue: null)
  String? profilePictureUrl;

  @HiveField(14, defaultValue: null)
  String? storeLatest;

  @HiveField(15, defaultValue: [])
  List<String> carts;

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
    required this.carts,
  });

  @override
  String toString() {
    return 'User(storeId: $storeId, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, email: $email, username: $username, profilePictureUrl: $profilePictureUrl, storeLatest: $storeLatest)';
  }
}
