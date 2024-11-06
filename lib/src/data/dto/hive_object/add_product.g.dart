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
      userId: fields[7] as String,
      storeId: fields[8] as String,
      addProductItems:
          fields[9] == null ? [] : (fields[9] as List).cast<OrderItem>(),
      id: fields[1] as dynamic,
      amountCost: fields[10] == null ? 0 : fields[10] as num,
    )
      ..createDate = fields[2] as dynamic
      ..createBy = fields[3] as String?
      ..updateDate = fields[4] as DateTime?
      ..updateBy = fields[5] as String?
      ..syncDatetime = fields[6] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, AddProduct obj) {
    writer
      ..writeByte(10)
      ..writeByte(7)
      ..write(obj.userId)
      ..writeByte(8)
      ..write(obj.storeId)
      ..writeByte(9)
      ..write(obj.addProductItems)
      ..writeByte(10)
      ..write(obj.amountCost)
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
      other is AddProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddProduct _$AddProductFromJson(Map<String, dynamic> json) => AddProduct(
      userId: json['userId'] as String,
      storeId: json['storeId'] as String,
      addProductItems: (json['addProductItems'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'],
      amountCost: json['amountCost'] as num,
    )
      ..createDate = json['createDate']
      ..createBy = json['createBy'] as String?
      ..updateDate = json['updateDate'] == null
          ? null
          : DateTime.parse(json['updateDate'] as String)
      ..updateBy = json['updateBy'] as String?
      ..syncDatetime = json['syncDatetime'] == null
          ? null
          : DateTime.parse(json['syncDatetime'] as String);

Map<String, dynamic> _$AddProductToJson(AddProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createDate': instance.createDate,
      'createBy': instance.createBy,
      'updateDate': instance.updateDate?.toIso8601String(),
      'updateBy': instance.updateBy,
      'syncDatetime': instance.syncDatetime?.toIso8601String(),
      'userId': instance.userId,
      'storeId': instance.storeId,
      'addProductItems': instance.addProductItems,
      'amountCost': instance.amountCost,
    };
