import 'package:hive/hive.dart';

import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product extends BaseHiveObject {
  @HiveField(6)
  String name;

  @HiveField(7, defaultValue: null)
  String? description;

  @HiveField(8, defaultValue: null)
  num? price;

  @HiveField(9, defaultValue: null)
  String? category;

  @HiveField(10, defaultValue: null)
  String? brand;

  @HiveField(11, defaultValue: null)
  List<String>? imageDetail;

  @HiveField(12, defaultValue: null)
  String? imageThumbnail;

  @HiveField(13, defaultValue: {})
  Map<String, dynamic>? attributes;

  @HiveField(14, defaultValue: [])
  List<String>? tag;

  @HiveField(15, defaultValue: ProductStatus.undefined)
  ProductStatus status;

  @HiveField(16, defaultValue: null)
  String? image;

  @HiveField(17, defaultValue: null)
  String? imageName;

  Product({
    required super.id,
    super.createDate,
    super.createBy,
    super.updateDate,
    super.updateBy,
    required this.name,
    required this.description,
    this.price,
    required this.category,
    this.image,
    this.imageDetail,
    this.imageThumbnail,
    required this.brand,
    required this.status,
    this.tag,
    this.attributes,
    this.imageName,
  });

  @override
  String toString() {
    return 'Product(name: $name, description: $description, price: $price, category: $category, brand: $brand, imageDetail: $imageDetail, imageThumbnail: $imageThumbnail, attributes: $attributes, tag: $tag, createDate: $createDate, createBy: $createBy, updateDate: $updateDate, updateBy: $updateBy, image: $image)';
  }
}

@HiveType(typeId: 2)
enum ProductStatus {
  @HiveField(0)
  active,
  @HiveField(1)
  inactive,
  @HiveField(2)
  discontinued,
  @HiveField(3)
  outOfStock,
  @HiveField(4)
  undefined;

  static ProductStatus fromString(String? value) {
    switch (value) {
      case 'active':
        return ProductStatus.active;
      case 'inactive':
        return ProductStatus.inactive;
      case 'discontinued':
        return ProductStatus.discontinued;
      case 'outOfStock':
        return ProductStatus.outOfStock;

      default:
        return ProductStatus.undefined;
    }
  }
}
