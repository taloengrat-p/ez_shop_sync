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
      createDate: fields[1] as dynamic,
      createBy: fields[2] as dynamic,
      updateDate: fields[3] as dynamic,
      updateBy: fields[4] as String?,
      syncDatetime: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, BaseHiveData obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.createDate)
      ..writeByte(2)
      ..write(obj.createBy)
      ..writeByte(3)
      ..write(obj.updateDate)
      ..writeByte(4)
      ..write(obj.updateBy)
      ..writeByte(5)
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
      createDate: json['createDate'],
      createBy: json['createBy'],
      updateDate: json['updateDate'],
      updateBy: json['updateBy'] as String?,
      syncDatetime: json['syncDatetime'] == null
          ? null
          : DateTime.parse(json['syncDatetime'] as String),
    );

Map<String, dynamic> _$BaseHiveDataToJson(BaseHiveData instance) =>
    <String, dynamic>{
      'createDate': instance.createDate,
      'createBy': instance.createBy,
      'updateDate': instance.updateDate,
      'updateBy': instance.updateBy,
      'syncDatetime': instance.syncDatetime?.toIso8601String(),
    };
