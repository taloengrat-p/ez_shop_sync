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
      id: fields[1] as String,
      name: fields[7] as String,
      description: fields[8] as String?,
      priceCategories:
          fields[9] == null ? {} : (fields[9] as Map?)?.cast<String, num>(),
      category: fields[10] as String?,
      brand: fields[11] as String?,
      imageDetail: (fields[12] as List?)?.cast<String>(),
      imageThumbnail: fields[13] as String?,
      attributes: fields[14] == null
          ? {}
          : (fields[14] as Map?)?.cast<String, dynamic>(),
      tag: fields[15] == null ? [] : (fields[15] as List?)?.cast<String>(),
      image: fields[17] as String?,
      imageName: fields[18] as String?,
      storeId: fields[19] as String,
      status: fields[16] == null
          ? ProductStatus.undefined
          : fields[16] as ProductStatus,
      quantity: fields[20] as num?,
      ownerId: fields[21] as String,
      priceSelected: fields[22] as String?,
    )
      ..createDate = fields[2] as DateTime?
      ..createBy = fields[3] as String?
      ..updateDate = fields[4] as DateTime?
      ..updateBy = fields[5] as String?
      ..syncDatetime = fields[6] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(22)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.priceCategories)
      ..writeByte(10)
      ..write(obj.category)
      ..writeByte(11)
      ..write(obj.brand)
      ..writeByte(12)
      ..write(obj.imageDetail)
      ..writeByte(13)
      ..write(obj.imageThumbnail)
      ..writeByte(14)
      ..write(obj.attributes)
      ..writeByte(15)
      ..write(obj.tag)
      ..writeByte(16)
      ..write(obj.status)
      ..writeByte(17)
      ..write(obj.image)
      ..writeByte(18)
      ..write(obj.imageName)
      ..writeByte(19)
      ..write(obj.storeId)
      ..writeByte(20)
      ..write(obj.quantity)
      ..writeByte(21)
      ..write(obj.ownerId)
      ..writeByte(22)
      ..write(obj.priceSelected)
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
