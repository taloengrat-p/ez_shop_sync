// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 7;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      name: fields[6] as String,
      id: fields[1] as String,
      parentId: fields[7] as String?,
    )
      ..createDate = fields[2] as DateTime?
      ..createBy = fields[3] as DateTime?
      ..updateDate = fields[4] as DateTime?
      ..updateBy = fields[5] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(7)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.parentId)
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
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
