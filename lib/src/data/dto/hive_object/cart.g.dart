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
      id: fields[1] as dynamic,
      createDate: fields[2] as dynamic,
      createBy: fields[3] as String?,
      updateDate: fields[4] as DateTime?,
      updateBy: fields[5] as String?,
      syncDatetime: fields[6] as DateTime?,
      cartItems: fields[9] == null ? [] : (fields[9] as List).cast<OrderItem>(),
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
      id: json['id'],
      createDate: json['createDate'],
      createBy: json['createBy'] as String?,
      updateDate: json['updateDate'] == null
          ? null
          : DateTime.parse(json['updateDate'] as String),
      updateBy: json['updateBy'] as String?,
      syncDatetime: json['syncDatetime'] == null
          ? null
          : DateTime.parse(json['syncDatetime'] as String),
      cartItems: (json['cartItems'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      storeId: json['storeId'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
      'id': instance.id,
      'createDate': instance.createDate,
      'createBy': instance.createBy,
      'updateDate': instance.updateDate?.toIso8601String(),
      'updateBy': instance.updateBy,
      'syncDatetime': instance.syncDatetime?.toIso8601String(),
      'userId': instance.userId,
      'storeId': instance.storeId,
      'cartItems': instance.cartItems.map((e) => e.toJson()).toList(),
    };
