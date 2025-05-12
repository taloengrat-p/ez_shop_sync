// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_hive_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BaseHiveDataAdapter extends TypeAdapter<BaseHiveData> {
  @override
  final int typeId = 17;

  @override
  BaseHiveData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BaseHiveData(
      storeId: fields[1] as String?,
      branchId: fields[2] as String?,
      createBy: fields[3] as String?,
      updateBy: fields[4] as String?,
      createAt: fields[5] as dynamic,
      updateAt: fields[6] as dynamic,
      syncDatetime: fields[7] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, BaseHiveData obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.storeId)
      ..writeByte(2)
      ..write(obj.branchId)
      ..writeByte(3)
      ..write(obj.createBy)
      ..writeByte(4)
      ..write(obj.updateBy)
      ..writeByte(5)
      ..write(obj.createAt)
      ..writeByte(6)
      ..write(obj.updateAt)
      ..writeByte(7)
      ..write(obj.syncDatetime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseHiveDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseHiveData _$BaseHiveDataFromJson(Map<String, dynamic> json) => BaseHiveData(
      storeId: json['storeId'] as String?,
      branchId: json['branchId'] as String?,
      createBy: json['createBy'] as String?,
      updateBy: json['updateBy'] as String?,
      createAt: json['createAt'],
      updateAt: json['updateAt'],
      syncDatetime: json['syncDatetime'],
    );

Map<String, dynamic> _$BaseHiveDataToJson(BaseHiveData instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'branchId': instance.branchId,
      'createBy': instance.createBy,
      'updateBy': instance.updateBy,
      'createAt': instance.createAt,
      'updateAt': instance.updateAt,
      'syncDatetime': instance.syncDatetime,
    };
