// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductConfigAdapter extends TypeAdapter<ProductConfig> {
  @override
  final int typeId = 13;

  @override
  ProductConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductConfig(
      enabled: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProductConfig obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.enabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductConfig _$ProductConfigFromJson(Map<String, dynamic> json) =>
    ProductConfig(
      enabled: json['enabled'] as bool,
    );

Map<String, dynamic> _$ProductConfigToJson(ProductConfig instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
    };
