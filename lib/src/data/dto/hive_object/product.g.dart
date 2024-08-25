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
      name: fields[2] as String,
      description: fields[3] as String,
      price: fields[4] as num,
      category: fields[5] as String,
      image: fields[16] as String?,
      imageDetail: (fields[7] as List?)?.cast<String>(),
      imageThumbnail: fields[8] as String?,
      brand: fields[6] as String,
      status: fields[11] == null
          ? ProductStatus.undefined
          : fields[11] as ProductStatus,
      tag: fields[10] == null ? [] : (fields[10] as List?)?.cast<String>(),
      attributes:
          fields[9] == null ? {} : (fields[9] as Map?)?.cast<String, dynamic>(),
      createDate: fields[12] as DateTime?,
      createBy: fields[13] as DateTime?,
      updateDate: fields[14] as DateTime?,
      updateBy: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(16)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.brand)
      ..writeByte(7)
      ..write(obj.imageDetail)
      ..writeByte(8)
      ..write(obj.imageThumbnail)
      ..writeByte(9)
      ..write(obj.attributes)
      ..writeByte(10)
      ..write(obj.tag)
      ..writeByte(11)
      ..write(obj.status)
      ..writeByte(12)
      ..write(obj.createDate)
      ..writeByte(13)
      ..write(obj.createBy)
      ..writeByte(14)
      ..write(obj.updateDate)
      ..writeByte(15)
      ..write(obj.updateBy)
      ..writeByte(16)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.id);
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
