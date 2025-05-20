// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_type.enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoleTypeAdapter extends TypeAdapter<RoleType> {
  @override
  final int typeId = 23;

  @override
  RoleType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RoleType.owner;
      case 1:
        return RoleType.admin;
      case 2:
        return RoleType.manager;
      case 3:
        return RoleType.staff;
      case 4:
        return RoleType.user;
      case 5:
        return RoleType.anonymous;
      case 6:
        return RoleType.undefined;
      default:
        return RoleType.owner;
    }
  }

  @override
  void write(BinaryWriter writer, RoleType obj) {
    switch (obj) {
      case RoleType.owner:
        writer.writeByte(0);
        break;
      case RoleType.admin:
        writer.writeByte(1);
        break;
      case RoleType.manager:
        writer.writeByte(2);
        break;
      case RoleType.staff:
        writer.writeByte(3);
        break;
      case RoleType.user:
        writer.writeByte(4);
        break;
      case RoleType.anonymous:
        writer.writeByte(5);
        break;
      case RoleType.undefined:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
