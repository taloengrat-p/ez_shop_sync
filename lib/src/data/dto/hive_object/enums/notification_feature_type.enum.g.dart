// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_feature_type.enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationFeatureTypeAdapter
    extends TypeAdapter<NotificationFeatureType> {
  @override
  final int typeId = 22;

  @override
  NotificationFeatureType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationFeatureType.orderSuccess;
      default:
        return NotificationFeatureType.orderSuccess;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationFeatureType obj) {
    switch (obj) {
      case NotificationFeatureType.orderSuccess:
        writer.writeByte(0);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationFeatureTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
