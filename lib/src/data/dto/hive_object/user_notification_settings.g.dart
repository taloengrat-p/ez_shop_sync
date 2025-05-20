// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notification_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserNotificationSettingsAdapter
    extends TypeAdapter<UserNotificationSettings> {
  @override
  final int typeId = 21;

  @override
  UserNotificationSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserNotificationSettings(
      feature: fields[0] as NotificationFeatureType,
      role: fields[1] == null ? RoleType.undefined : fields[1] as RoleType,
      value: fields[2] == null ? false : fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserNotificationSettings obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.feature)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserNotificationSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserNotificationSettings _$UserNotificationSettingsFromJson(
        Map<String, dynamic> json) =>
    UserNotificationSettings(
      feature: $enumDecode(_$NotificationFeatureTypeEnumMap, json['feature']),
      role: $enumDecode(_$RoleTypeEnumMap, json['role']),
      value: json['value'] as bool,
    );

Map<String, dynamic> _$UserNotificationSettingsToJson(
        UserNotificationSettings instance) =>
    <String, dynamic>{
      'feature': _$NotificationFeatureTypeEnumMap[instance.feature]!,
      'role': _$RoleTypeEnumMap[instance.role]!,
      'value': instance.value,
    };

const _$NotificationFeatureTypeEnumMap = {
  NotificationFeatureType.orderSuccess: 'orderSuccess',
};

const _$RoleTypeEnumMap = {
  RoleType.owner: 'owner',
  RoleType.admin: 'admin',
  RoleType.manager: 'manager',
  RoleType.staff: 'staff',
  RoleType.user: 'user',
  RoleType.anonymous: 'anonymous',
  RoleType.undefined: 'undefined',
};
