// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreAdapter extends TypeAdapter<Store> {
  @override
  final int typeId = 3;

  @override
  Store read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Store(
      id: fields[1] as String,
      createDate: fields[2] as DateTime?,
      createBy: fields[3] as DateTime?,
      updateDate: fields[4] as DateTime?,
      updateBy: fields[5] as DateTime?,
      ownerId: fields[6] as String,
      name: fields[7] as String,
      address: fields[8] as String?,
      phoneNumbers: (fields[9] as List?)?.cast<String>(),
      email: fields[10] as String?,
      website: fields[11] as String?,
      description: fields[12] as String?,
      images: (fields[13] as List?)?.cast<String>(),
      tags: fields[14] == null ? [] : (fields[14] as List?)?.cast<String>(),
      storeTheme: fields[15] as AppTheme?,
      categories:
          fields[16] == null ? [] : (fields[16] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Store obj) {
    writer
      ..writeByte(16)
      ..writeByte(6)
      ..write(obj.ownerId)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.address)
      ..writeByte(9)
      ..write(obj.phoneNumbers)
      ..writeByte(10)
      ..write(obj.email)
      ..writeByte(11)
      ..write(obj.website)
      ..writeByte(12)
      ..write(obj.description)
      ..writeByte(13)
      ..write(obj.images)
      ..writeByte(14)
      ..write(obj.tags)
      ..writeByte(15)
      ..write(obj.storeTheme)
      ..writeByte(16)
      ..write(obj.categories)
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
      other is StoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
