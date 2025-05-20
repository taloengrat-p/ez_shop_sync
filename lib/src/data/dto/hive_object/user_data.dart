// ignore_for_file: type_init_formals

import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user_notification_settings.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@HiveType(typeId: 4)
@JsonSerializable(explicitToJson: true)
class UserData extends BaseHiveObject {
  @HiveField(3)
  final String uid;

  @HiveField(4, defaultValue: null)
  final String? storeSelected;

  @HiveField(5, defaultValue: [])
  final List<String>? stores;

  @HiveField(6)
  final String? displayName;

  @HiveField(7, defaultValue: null)
  final String? branchSelected;

  @HiveField(8, defaultValue: [])
  final List<UserNotificationSettings>? notificationSettings;

  UserData({
    super.id,
    BaseHiveData? super.info,
    required this.uid,
    this.storeSelected,
    this.stores,
    this.displayName,
    this.branchSelected,
    this.notificationSettings,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
