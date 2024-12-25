// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductOrderAdapter extends TypeAdapter<ProductOrder> {
  @override
  final int typeId = 12;

  @override
  ProductOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductOrder(
      id: fields[1] as dynamic,
      info: fields[2] as BaseHiveData?,
      storeId: fields[11] == null ? '' : fields[11] as String,
      userId: fields[12] == null ? '' : fields[12] as String,
      status: fields[7] as String,
      orderItems: (fields[9] as List).cast<OrderItem>(),
      paymentType: fields[8] as String,
      receiveAmount: fields[15] as num?,
    )
      ..serviceCharge = fields[10] == null ? 0 : fields[10] as num?
      ..createAt = fields[13] as dynamic
      ..changeAmount = fields[14] as num?;
  }

  @override
  void write(BinaryWriter writer, ProductOrder obj) {
    writer
      ..writeByte(11)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.paymentType)
      ..writeByte(9)
      ..write(obj.orderItems)
      ..writeByte(10)
      ..write(obj.serviceCharge)
      ..writeByte(11)
      ..write(obj.storeId)
      ..writeByte(12)
      ..write(obj.userId)
      ..writeByte(13)
      ..write(obj.createAt)
      ..writeByte(14)
      ..write(obj.changeAmount)
      ..writeByte(15)
      ..write(obj.receiveAmount)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.info);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOrder _$ProductOrderFromJson(Map<String, dynamic> json) => ProductOrder(
      id: json['id'],
      info: json['info'] == null
          ? null
          : BaseHiveData.fromJson(json['info'] as Map<String, dynamic>),
      storeId: json['storeId'] as String,
      userId: json['userId'] as String,
      status: json['status'] as String,
      orderItems: (json['orderItems'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentType: json['paymentType'] as String,
      receiveAmount: json['receiveAmount'] as num?,
    )
      ..serviceCharge = json['serviceCharge'] as num?
      ..createAt = json['createAt']
      ..changeAmount = json['changeAmount'] as num?;

Map<String, dynamic> _$ProductOrderToJson(ProductOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'info': instance.info?.toJson(),
      'status': instance.status,
      'paymentType': instance.paymentType,
      'orderItems': instance.orderItems.map((e) => e.toJson()).toList(),
      'serviceCharge': instance.serviceCharge,
      'storeId': instance.storeId,
      'userId': instance.userId,
      'createAt': instance.createAt,
      'changeAmount': instance.changeAmount,
      'receiveAmount': instance.receiveAmount,
    };
