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
      storeId: fields[6] == null ? [] : (fields[6] as List?)?.cast<String>(),
      firstName: fields[7] as String,
      lastName: fields[8] as String,
      phoneNumber: fields[9] as String?,
      email: fields[10] as String,
      username: fields[11] as String,
      profilePictureUrl: fields[12] as String?,
      storeLatest: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(13)
      ..writeByte(6)
      ..write(obj.storeId)
      ..writeByte(7)
      ..write(obj.firstName)
      ..writeByte(8)
      ..write(obj.lastName)
      ..writeByte(9)
      ..write(obj.phoneNumber)
      ..writeByte(10)
      ..write(obj.email)
      ..writeByte(11)
      ..write(obj.username)
      ..writeByte(12)
      ..write(obj.profilePictureUrl)
      ..writeByte(13)
      ..write(obj.storeLatest)
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
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
