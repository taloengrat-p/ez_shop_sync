// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartAdapter extends TypeAdapter<Cart> {
  @override
  final int typeId = 8;

  @override
  Cart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cart(
      id: fields[1] as String,
      createDate: fields[2] as DateTime?,
      createBy: fields[3] as String?,
      updateDate: fields[4] as DateTime?,
      updateBy: fields[5] as String?,
      syncDatetime: fields[6] as DateTime?,
      cartItems: fields[9] == null ? [] : (fields[9] as List).cast<CartItem>(),
      storeId: fields[8] as String,
      userId: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Cart obj) {
    writer
      ..writeByte(9)
      ..writeByte(7)
      ..write(obj.userId)
      ..writeByte(8)
      ..write(obj.storeId)
      ..writeByte(9)
      ..write(obj.cartItems)
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
      other is CartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
