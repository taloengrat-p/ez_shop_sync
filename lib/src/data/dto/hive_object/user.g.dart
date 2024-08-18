// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 3;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[1] as String,
      storeId: fields[2] == null ? [] : (fields[2] as List?)?.cast<String>(),
      firstName: fields[3] as String,
      lastName: fields[4] as String,
      phoneNumber: fields[5] as String,
      email: fields[6] as String,
      username: fields[7] as String,
      profilePictureUrl: fields[8] as String,
      password: fields[9] as String,
      passwordSalt: fields[10] as String,
      pin: fields[11] as String,
      pinSalt: fields[12] as String,
      createDate: fields[13] as DateTime?,
      createBy: fields[14] as DateTime?,
      updateDate: fields[15] as DateTime?,
      updateBy: fields[16] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(16)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.storeId)
      ..writeByte(3)
      ..write(obj.firstName)
      ..writeByte(4)
      ..write(obj.lastName)
      ..writeByte(5)
      ..write(obj.phoneNumber)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.username)
      ..writeByte(8)
      ..write(obj.profilePictureUrl)
      ..writeByte(9)
      ..write(obj.password)
      ..writeByte(10)
      ..write(obj.passwordSalt)
      ..writeByte(11)
      ..write(obj.pin)
      ..writeByte(12)
      ..write(obj.pinSalt)
      ..writeByte(13)
      ..write(obj.createDate)
      ..writeByte(14)
      ..write(obj.createBy)
      ..writeByte(15)
      ..write(obj.updateDate)
      ..writeByte(16)
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
