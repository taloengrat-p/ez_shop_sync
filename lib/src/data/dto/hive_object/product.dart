import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product extends BaseHiveObject {
  @HiveField(2)
  String name;

  @HiveField(3)
  String description;

  @HiveField(4)
  num price;

  @HiveField(5)
  String category;

  @HiveField(6)
  String brand;

  @HiveField(7, defaultValue: null)
  List<String>? imageDetail;

  @HiveField(8, defaultValue: null)
  String? imageThumbnail;

  @HiveField(9, defaultValue: {})
  Map<String, dynamic>? attributes;

  @HiveField(10, defaultValue: [])
  List<String>? tag;

  @HiveField(11, defaultValue: ProductStatus.undefined)
  ProductStatus status;

  @HiveField(12, defaultValue: null)
  DateTime? createDate;

  @HiveField(13, defaultValue: null)
  DateTime? createBy;

  @HiveField(14, defaultValue: null)
  DateTime? updateDate;

  @HiveField(15, defaultValue: null)
  DateTime? updateBy;

  @HiveField(16, defaultValue: null)
  String? image;

  Product({
    required super.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.image,
    this.imageDetail,
    this.imageThumbnail,
    required this.brand,
    required this.status,
    this.tag,
    this.attributes,
    this.createDate,
    this.createBy,
    this.updateDate,
    this.updateBy,
  });

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, price: $price, category: $category, brand: $brand, imageDetail: $imageDetail, imageThumbnail: $imageThumbnail, attributes: $attributes, tag: $tag, createDate: $createDate, createBy: $createBy, updateDate: $updateDate, updateBy: $updateBy)';
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
