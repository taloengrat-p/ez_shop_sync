// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TagAdapter extends TypeAdapter<Tag> {
  @override
  final int typeId = 5;

  @override
  Tag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tag(
      id: fields[1] as String,
      name: fields[7] as String,
      color: fields[8] as String?,
      borderColor: fields[9] as String?,
    )
      ..createDate = fields[2] as DateTime?
      ..createBy = fields[3] as String?
      ..updateDate = fields[4] as DateTime?
      ..updateBy = fields[5] as String?
      ..syncDatetime = fields[6] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Tag obj) {
    writer
      ..writeByte(9)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.color)
      ..writeByte(9)
      ..write(obj.borderColor)
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
      other is TagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String?,
      borderColor: json['borderColor'] as String?,
    )
      ..createDate = json['createDate'] == null
          ? null
          : DateTime.parse(json['createDate'] as String)
      ..createBy = json['createBy'] as String?
      ..updateDate = json['updateDate'] == null
          ? null
          : DateTime.parse(json['updateDate'] as String)
      ..updateBy = json['updateBy'] as String?
      ..syncDatetime = json['syncDatetime'] == null
          ? null
          : DateTime.parse(json['syncDatetime'] as String);

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'id': instance.id,
      'createDate': instance.createDate?.toIso8601String(),
      'createBy': instance.createBy,
      'updateDate': instance.updateDate?.toIso8601String(),
      'updateBy': instance.updateBy,
      'syncDatetime': instance.syncDatetime?.toIso8601String(),
      'name': instance.name,
      'color': instance.color,
      'borderColor': instance.borderColor,
    };
