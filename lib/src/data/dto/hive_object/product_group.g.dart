// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductGroupAdapter extends TypeAdapter<ProductGroup> {
  @override
  final int typeId = 16;

  @override
  ProductGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductGroup(
      id: fields[1] as dynamic,
      info: fields[2] as BaseHiveData?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductGroup obj) {
    writer
      ..writeByte(2)
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
      other is ProductGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductGroup _$ProductGroupFromJson(Map<String, dynamic> json) => ProductGroup(
      id: json['id'],
      info: json['info'] == null
          ? null
          : BaseHiveData.fromJson(json['info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductGroupToJson(ProductGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'info': instance.info?.toJson(),
    };
