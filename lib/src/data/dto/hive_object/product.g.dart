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
      id: fields[0] as String?,
      name: fields[1] as String,
      description: fields[2] as String,
      price: fields[3] as num,
      category: fields[4] as String,
      image: fields[15] as String?,
      imageDetail: (fields[6] as List?)?.cast<String>(),
      imageThumbnail: fields[7] as String?,
      brand: fields[5] as String,
      status: fields[10] == null
          ? ProductStatus.undefined
          : fields[10] as ProductStatus,
      tag: fields[9] == null ? [] : (fields[9] as List?)?.cast<String>(),
      attributes:
          fields[8] == null ? {} : (fields[8] as Map?)?.cast<String, dynamic>(),
      createDate: fields[11] as DateTime?,
      createBy: fields[12] as DateTime?,
      updateDate: fields[13] as DateTime?,
      updateBy: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.brand)
      ..writeByte(6)
      ..write(obj.imageDetail)
      ..writeByte(7)
      ..write(obj.imageThumbnail)
      ..writeByte(8)
      ..write(obj.attributes)
      ..writeByte(9)
      ..write(obj.tag)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.createDate)
      ..writeByte(12)
      ..write(obj.createBy)
      ..writeByte(13)
      ..write(obj.updateDate)
      ..writeByte(14)
      ..write(obj.updateBy)
      ..writeByte(15)
      ..write(obj.image);
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
