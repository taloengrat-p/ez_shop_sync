// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductHistoryAdapter extends TypeAdapter<ProductHistory> {
  @override
  final int typeId = 10;

  @override
  ProductHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductHistory(
      productId: fields[8] as String,
      id: fields[1] as String,
      event: fields[7] as String,
      newData: (fields[10] as Map?)?.cast<String, dynamic>(),
      oldData: (fields[9] as Map?)?.cast<String, dynamic>(),
    )
      ..createDate = fields[2] as DateTime?
      ..createBy = fields[3] as String?
      ..updateDate = fields[4] as DateTime?
      ..updateBy = fields[5] as String?
      ..syncDatetime = fields[6] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, ProductHistory obj) {
    writer
      ..writeByte(10)
      ..writeByte(7)
      ..write(obj.event)
      ..writeByte(8)
      ..write(obj.productId)
      ..writeByte(9)
      ..write(obj.oldData)
      ..writeByte(10)
      ..write(obj.newData)
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
      other is ProductHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
