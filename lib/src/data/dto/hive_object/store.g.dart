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
      createBy: fields[3] as String?,
      updateDate: fields[4] as DateTime?,
      updateBy: fields[5] as String?,
      ownerId: fields[7] as String,
      name: fields[8] as String,
      address: fields[9] as String?,
      phoneNumbers: (fields[10] as List?)?.cast<String>(),
      email: fields[11] as String?,
      website: fields[12] as String?,
      description: fields[13] as String?,
      images: (fields[14] as List?)?.cast<String>(),
      tags: fields[15] == null ? [] : (fields[15] as List?)?.cast<String>(),
      storeTheme: fields[16] as AppTheme?,
      categories:
          fields[17] == null ? [] : (fields[17] as List?)?.cast<String>(),
      members: fields[18] == null ? [] : (fields[18] as List?)?.cast<Member>(),
    )..syncDatetime = fields[6] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Store obj) {
    writer
      ..writeByte(18)
      ..writeByte(7)
      ..write(obj.ownerId)
      ..writeByte(8)
      ..write(obj.name)
      ..writeByte(9)
      ..write(obj.address)
      ..writeByte(10)
      ..write(obj.phoneNumbers)
      ..writeByte(11)
      ..write(obj.email)
      ..writeByte(12)
      ..write(obj.website)
      ..writeByte(13)
      ..write(obj.description)
      ..writeByte(14)
      ..write(obj.images)
      ..writeByte(15)
      ..write(obj.tags)
      ..writeByte(16)
      ..write(obj.storeTheme)
      ..writeByte(17)
      ..write(obj.categories)
      ..writeByte(18)
      ..write(obj.members)
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
      other is StoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
