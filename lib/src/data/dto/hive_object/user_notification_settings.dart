// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/notification_feature_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/role_type.enum.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_notification_settings.g.dart';

@HiveType(typeId: 21)
@JsonSerializable()
class UserNotificationSettings {
  @HiveField(0)
  NotificationFeatureType feature;

  @HiveField(1, defaultValue: RoleType.undefined)
  RoleType role;

  @HiveField(2, defaultValue: false)
  bool value;

  UserNotificationSettings({required this.feature, required this.role, required this.value});

  factory UserNotificationSettings.fromJson(Map<String, dynamic> json) => _$UserNotificationSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$UserNotificationSettingsToJson(this);
}
