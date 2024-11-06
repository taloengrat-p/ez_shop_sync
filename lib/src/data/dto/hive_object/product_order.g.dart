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
      storeId: fields[11] == null ? '' : fields[11] as String,
      id: fields[1] as dynamic,
      status: fields[7] as String,
      cartItems: fields[9] == null ? [] : (fields[9] as List).cast<OrderItem>(),
      paymentType: fields[8] as String,
    )
      ..serviceCharge = fields[10] == null ? 0 : fields[10] as num?
      ..createDate = fields[2] as dynamic
      ..createBy = fields[3] as String?
      ..updateDate = fields[4] as DateTime?
      ..updateBy = fields[5] as String?
      ..syncDatetime = fields[6] as DateTime?;
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
      ..write(obj.cartItems)
      ..writeByte(10)
      ..write(obj.serviceCharge)
      ..writeByte(11)
      ..write(obj.storeId)
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
      other is ProductOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOrder _$ProductOrderFromJson(Map<String, dynamic> json) => ProductOrder(
      storeId: json['storeId'] as String,
      id: json['id'],
      status: json['status'] as String,
      cartItems: (json['cartItems'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentType: json['paymentType'] as String,
    )
      ..createDate = json['createDate']
      ..createBy = json['createBy'] as String?
      ..updateDate = json['updateDate'] == null
          ? null
          : DateTime.parse(json['updateDate'] as String)
      ..updateBy = json['updateBy'] as String?
      ..syncDatetime = json['syncDatetime'] == null
          ? null
          : DateTime.parse(json['syncDatetime'] as String)
      ..serviceCharge = json['serviceCharge'] as num?;

Map<String, dynamic> _$ProductOrderToJson(ProductOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createDate': instance.createDate,
      'createBy': instance.createBy,
      'updateDate': instance.updateDate?.toIso8601String(),
      'updateBy': instance.updateBy,
      'syncDatetime': instance.syncDatetime?.toIso8601String(),
      'status': instance.status,
      'paymentType': instance.paymentType,
      'cartItems': instance.cartItems,
      'serviceCharge': instance.serviceCharge,
      'storeId': instance.storeId,
    };
