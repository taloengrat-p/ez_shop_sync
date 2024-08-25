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
      ownerId: fields[2] as String,
      name: fields[3] as String,
      address: fields[4] as String?,
      phoneNumbers: (fields[5] as List?)?.cast<String>(),
      email: fields[6] as String?,
      website: fields[7] as String?,
      description: fields[8] as String?,
      images: (fields[9] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Store obj) {
    writer
      ..writeByte(9)
      ..writeByte(2)
      ..write(obj.ownerId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.phoneNumbers)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.website)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.images)
      ..writeByte(1)
      ..write(obj.id);
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
