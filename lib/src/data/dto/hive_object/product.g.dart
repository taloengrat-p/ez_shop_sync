// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 1;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[1] as dynamic,
      info: fields[2] as BaseHiveData?,
      name: fields[7] as String,
      description: fields[8] as String?,
      category: fields[9] as String?,
      brand: fields[10] as String?,
      imageUrl: fields[23] as String?,
      imagesUrl: (fields[11] as List?)?.cast<String>(),
      imageThumbnail: fields[12] as String?,
      attributes: fields[13] == null
          ? {}
          : (fields[13] as Map?)?.cast<String, dynamic>(),
      tag: fields[14] == null ? [] : (fields[14] as List?)?.cast<String>(),
      storeId: fields[16] as String,
      status: fields[15] == null
          ? ProductStatus.undefined
          : fields[15] as ProductStatus,
      quantity: fields[17] as num?,
      ownerId: fields[18] as String,
      priceSelected: fields[19] as String?,
      productTypeList: (fields[21] as List?)?.cast<ProductType>(),
    )..config = fields[20] as ProductConfig?;
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(18)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.category)
      ..writeByte(10)
      ..write(obj.brand)
      ..writeByte(23)
      ..write(obj.imageUrl)
      ..writeByte(11)
      ..write(obj.imagesUrl)
      ..writeByte(12)
      ..write(obj.imageThumbnail)
      ..writeByte(13)
      ..write(obj.attributes)
      ..writeByte(14)
      ..write(obj.tag)
      ..writeByte(15)
      ..write(obj.status)
      ..writeByte(16)
      ..write(obj.storeId)
      ..writeByte(17)
      ..write(obj.quantity)
      ..writeByte(18)
      ..write(obj.ownerId)
      ..writeByte(19)
      ..write(obj.priceSelected)
      ..writeByte(20)
      ..write(obj.config)
      ..writeByte(21)
      ..write(obj.productTypeList)
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
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductStatusAdapter extends TypeAdapter<ProductStatus> {
  @override
  final int typeId = 2;

  @override
  ProductStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProductStatus.active;
      case 1:
        return ProductStatus.inactive;
      case 2:
        return ProductStatus.discontinued;
      case 3:
        return ProductStatus.outOfStock;
      case 4:
        return ProductStatus.undefined;
      default:
        return ProductStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, ProductStatus obj) {
    switch (obj) {
      case ProductStatus.active:
        writer.writeByte(0);
        break;
      case ProductStatus.inactive:
        writer.writeByte(1);
        break;
      case ProductStatus.discontinued:
        writer.writeByte(2);
        break;
      case ProductStatus.outOfStock:
        writer.writeByte(3);
        break;
      case ProductStatus.undefined:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'],
      info: json['info'] == null
          ? null
          : BaseHiveData.fromJson(json['info'] as Map<String, dynamic>),
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      brand: json['brand'] as String?,
      imageUrl: json['imageUrl'] as String?,
      imagesUrl: (json['imagesUrl'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      imageThumbnail: json['imageThumbnail'] as String?,
      attributes: json['attributes'] as Map<String, dynamic>?,
      tag: (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList(),
      storeId: json['storeId'] as String,
      status: $enumDecode(_$ProductStatusEnumMap, json['status']),
      quantity: json['quantity'] as num?,
      ownerId: json['ownerId'] as String,
      priceSelected: json['priceSelected'] as String?,
      productTypeList: (json['productTypeList'] as List<dynamic>?)
          ?.map((e) => ProductType.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..config = json['config'] == null
        ? null
        : ProductConfig.fromJson(json['config'] as Map<String, dynamic>);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'info': instance.info?.toJson(),
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'brand': instance.brand,
      'imageUrl': instance.imageUrl,
      'imagesUrl': instance.imagesUrl,
      'imageThumbnail': instance.imageThumbnail,
      'attributes': instance.attributes,
      'tag': instance.tag,
      'status': _$ProductStatusEnumMap[instance.status]!,
      'storeId': instance.storeId,
      'quantity': instance.quantity,
      'ownerId': instance.ownerId,
      'priceSelected': instance.priceSelected,
      'config': instance.config?.toJson(),
      'productTypeList':
          instance.productTypeList?.map((e) => e.toJson()).toList(),
    };

const _$ProductStatusEnumMap = {
  ProductStatus.active: 'active',
  ProductStatus.inactive: 'inactive',
  ProductStatus.discontinued: 'discontinued',
  ProductStatus.outOfStock: 'outOfStock',
  ProductStatus.undefined: 'undefined',
};
