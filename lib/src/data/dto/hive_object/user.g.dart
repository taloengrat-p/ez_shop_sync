// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 4;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[1] as String,
      createDate: fields[2] as DateTime?,
      createBy: fields[3] as String?,
      updateDate: fields[4] as DateTime?,
      updateBy: fields[5] as String?,
      storeId: fields[7] == null ? [] : (fields[7] as List?)?.cast<String>(),
      firstName: fields[8] as String,
      lastName: fields[9] as String,
      phoneNumber: fields[10] as String?,
      email: fields[11] as String,
      username: fields[12] as String,
      profilePictureUrl: fields[13] as String?,
      storeLatest: fields[14] as String?,
      carts: fields[15] == null ? [] : (fields[15] as List).cast<String>(),
    )..syncDatetime = fields[6] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(15)
      ..writeByte(7)
      ..write(obj.storeId)
      ..writeByte(8)
      ..write(obj.firstName)
      ..writeByte(9)
      ..write(obj.lastName)
      ..writeByte(10)
      ..write(obj.phoneNumber)
      ..writeByte(11)
      ..write(obj.email)
      ..writeByte(12)
      ..write(obj.username)
      ..writeByte(13)
      ..write(obj.profilePictureUrl)
      ..writeByte(14)
      ..write(obj.storeLatest)
      ..writeByte(15)
      ..write(obj.carts)
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
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
