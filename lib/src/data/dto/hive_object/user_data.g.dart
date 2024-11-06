// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 4;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      id: fields[1] as dynamic,
      createDate: fields[2] as dynamic,
      createBy: fields[3] as String?,
      updateDate: fields[4] as DateTime?,
      updateBy: fields[5] as String?,
      uid: fields[7] as String,
      storeSelected: fields[8] as String?,
      stores: fields[9] == null ? [] : (fields[9] as List?)?.cast<String>(),
      displayName: fields[10] as String?,
    )..syncDatetime = fields[6] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(10)
      ..writeByte(7)
      ..write(obj.uid)
      ..writeByte(8)
      ..write(obj.storeSelected)
      ..writeByte(9)
      ..write(obj.stores)
      ..writeByte(10)
      ..write(obj.displayName)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.createDate)
      ..writeByte(3)
      ..write(obj.createBy)
      ..writeByte(4)
      ..write(obj.updateDate)
      ..writeByte(5)
      ..write(obj.updateBy)
      ..writeByte(6)
      ..write(obj.syncDatetime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: json['id'],
      createDate: json['createDate'],
      createBy: json['createBy'] as String?,
      updateDate: json['updateDate'] == null
          ? null
          : DateTime.parse(json['updateDate'] as String),
      updateBy: json['updateBy'] as String?,
      uid: json['uid'] as String,
      storeSelected: json['storeSelected'] as String?,
      stores:
          (json['stores'] as List<dynamic>?)?.map((e) => e as String).toList(),
      displayName: json['displayName'] as String?,
    )..syncDatetime = json['syncDatetime'] == null
        ? null
        : DateTime.parse(json['syncDatetime'] as String);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'createDate': instance.createDate,
      'createBy': instance.createBy,
      'updateDate': instance.updateDate?.toIso8601String(),
      'updateBy': instance.updateBy,
      'syncDatetime': instance.syncDatetime?.toIso8601String(),
      'uid': instance.uid,
      'storeSelected': instance.storeSelected,
      'stores': instance.stores,
      'displayName': instance.displayName,
    };
