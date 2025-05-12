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
      info: fields[2] as BaseHiveData?,
      uid: fields[7] as String,
      storeSelected: fields[8] as String?,
      stores: fields[9] == null ? [] : (fields[9] as List?)?.cast<String>(),
      displayName: fields[10] as String?,
      branchSelected: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(7)
      ..writeByte(7)
      ..write(obj.uid)
      ..writeByte(8)
      ..write(obj.storeSelected)
      ..writeByte(9)
      ..write(obj.stores)
      ..writeByte(10)
      ..write(obj.displayName)
      ..writeByte(11)
      ..write(obj.branchSelected)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.info);
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
      info: json['info'] == null
          ? null
          : BaseHiveData.fromJson(json['info'] as Map<String, dynamic>),
      uid: json['uid'] as String,
      storeSelected: json['storeSelected'] as String?,
      stores:
          (json['stores'] as List<dynamic>?)?.map((e) => e as String).toList(),
      displayName: json['displayName'] as String?,
      branchSelected: json['branchSelected'] as String?,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'info': instance.info?.toJson(),
      'uid': instance.uid,
      'storeSelected': instance.storeSelected,
      'stores': instance.stores,
      'displayName': instance.displayName,
      'branchSelected': instance.branchSelected,
    };
