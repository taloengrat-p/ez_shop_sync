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
      id: fields[1] as dynamic,
      info: fields[2] as BaseHiveData?,
      productId: fields[8] as String,
      event: fields[7] as String,
      newData: (fields[10] as Map?)?.cast<String, dynamic>(),
      oldData: (fields[9] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductHistory obj) {
    writer
      ..writeByte(6)
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
      ..write(obj.info);
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductHistory _$ProductHistoryFromJson(Map<String, dynamic> json) =>
    ProductHistory(
      id: json['id'],
      info: json['info'] == null
          ? null
          : BaseHiveData.fromJson(json['info'] as Map<String, dynamic>),
      productId: json['productId'] as String,
      event: json['event'] as String,
      newData: json['newData'] as Map<String, dynamic>?,
      oldData: json['oldData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ProductHistoryToJson(ProductHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'info': instance.info?.toJson(),
      'event': instance.event,
      'productId': instance.productId,
      'oldData': instance.oldData,
      'newData': instance.newData,
    };
