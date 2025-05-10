// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddProductAdapter extends TypeAdapter<AddProduct> {
  @override
  final int typeId = 15;

  @override
  AddProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddProduct(
      id: fields[1] as dynamic,
      info: fields[2] as BaseHiveData?,
      userId: fields[7] as String,
      storeId: fields[8] as String,
      addProductItems:
          fields[9] == null ? [] : (fields[9] as List).cast<OrderItem>(),
      amountCost: fields[10] == null ? 0 : fields[10] as num,
      paymentType: fields[11] == null
          ? PaymentMethodType.cash
          : fields[11] as PaymentMethodType?,
    );
  }

  @override
  void write(BinaryWriter writer, AddProduct obj) {
    writer
      ..writeByte(7)
      ..writeByte(7)
      ..write(obj.userId)
      ..writeByte(8)
      ..write(obj.storeId)
      ..writeByte(9)
      ..write(obj.addProductItems)
      ..writeByte(10)
      ..write(obj.amountCost)
      ..writeByte(11)
      ..write(obj.paymentType)
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
      other is AddProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddProduct _$AddProductFromJson(Map<String, dynamic> json) => AddProduct(
      id: json['id'],
      info: json['info'] == null
          ? null
          : BaseHiveData.fromJson(json['info'] as Map<String, dynamic>),
      userId: json['userId'] as String,
      storeId: json['storeId'] as String,
      addProductItems: (json['addProductItems'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      amountCost: json['amountCost'] as num,
      paymentType:
          $enumDecodeNullable(_$PaymentMethodTypeEnumMap, json['paymentType']),
    );

Map<String, dynamic> _$AddProductToJson(AddProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'info': instance.info?.toJson(),
      'userId': instance.userId,
      'storeId': instance.storeId,
      'addProductItems':
          instance.addProductItems.map((e) => e.toJson()).toList(),
      'amountCost': instance.amountCost,
      'paymentType': _$PaymentMethodTypeEnumMap[instance.paymentType],
    };

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.cash: 'cash',
  PaymentMethodType.qrcode: 'qrcode',
  PaymentMethodType.undefined: 'undefined',
};
