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
      name: fields[6] as String,
      color: fields[7] as String?,
      borderColor: fields[8] as String?,
    )
      ..createDate = fields[2] as DateTime?
      ..createBy = fields[3] as String?
      ..updateDate = fields[4] as DateTime?
      ..updateBy = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, Tag obj) {
    writer
      ..writeByte(8)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.color)
      ..writeByte(8)
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
      ..write(obj.updateBy);
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
