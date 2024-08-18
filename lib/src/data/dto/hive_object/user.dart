import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 3)
class User {
  @HiveField(1)
  String id;

  @HiveField(2, defaultValue: [])
  List<String>? storeId;

  @HiveField(3)
  String firstName;

  @HiveField(4)
  String lastName;

  @HiveField(5)
  String phoneNumber;

  @HiveField(6)
  String email;

  @HiveField(7)
  String username;

  @HiveField(8)
  String profilePictureUrl;

  @HiveField(9)
  String password;

  @HiveField(10)
  String passwordSalt;

  @HiveField(11)
  String pin;

  @HiveField(12)
  String pinSalt;

  @HiveField(13, defaultValue: null)
  DateTime? createDate;

  @HiveField(14, defaultValue: null)
  DateTime? createBy;

  @HiveField(15, defaultValue: null)
  DateTime? updateDate;

  @HiveField(16, defaultValue: null)
  DateTime? updateBy;

  User({
    required this.id,
    required this.storeId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.username,
    required this.profilePictureUrl,
    required this.password,
    required this.passwordSalt,
    required this.pin,
    required this.pinSalt,
    this.createDate,
    this.createBy,
    this.updateDate,
    this.updateBy,
  });
}
