// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_local_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppLocalSessionAdapter extends TypeAdapter<AppLocalSession> {
  @override
  final int typeId = 5;

  @override
  AppLocalSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppLocalSession(
      user: fields[1] as User?,
    );
  }

  @override
  void write(BinaryWriter writer, AppLocalSession obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.user);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppLocalSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
