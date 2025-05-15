// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnitTypeAdapter extends TypeAdapter<UnitType> {
  @override
  final int typeId = 20;

  @override
  UnitType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnitType(
      name: fields[3] as StringLocale,
      info: fields[2] as BaseHiveData?,
      id: fields[1] as dynamic,
      shortName: fields[4] as StringLocale,
    );
  }

  @override
  void write(BinaryWriter writer, UnitType obj) {
    writer
      ..writeByte(4)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.shortName)
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
      other is UnitTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitType _$UnitTypeFromJson(Map<String, dynamic> json) => UnitType(
      name: StringLocale.fromJson(json['name'] as Map<String, dynamic>),
      info: json['info'] == null
          ? null
          : BaseHiveData.fromJson(json['info'] as Map<String, dynamic>),
      id: json['id'],
      shortName:
          StringLocale.fromJson(json['shortName'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UnitTypeToJson(UnitType instance) => <String, dynamic>{
      'id': instance.id,
      'info': instance.info?.toJson(),
      'name': instance.name.toJson(),
      'shortName': instance.shortName.toJson(),
    };
