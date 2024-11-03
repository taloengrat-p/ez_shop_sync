import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';

part 'add_product.g.dart';

@HiveType(typeId: 15)
@JsonSerializable()
class AddProduct extends BaseHiveObject {
  @HiveField(7)
  String userId;

  @HiveField(8)
  String storeId;

  @HiveField(9, defaultValue: [])
  List<OrderItem> addProductItems;

  @HiveField(10, defaultValue: 0)
  num amountCost;

  AddProduct({
    required this.userId,
    required this.storeId,
    required this.addProductItems,
    super.id,
    required this.amountCost,
  });

  factory AddProduct.fromJson(Map<String, dynamic> json) => _$AddProductFromJson(json);

  num get numberOfItems => addProductItems.fold(0, (sum, item) => sum + (item.product?.quantity ?? 0));

  @override
  Map<String, dynamic> toJson() => _$AddProductToJson(this);

  AddProduct copyWith({
    String? userId,
    String? storeId,
    List<OrderItem>? addProductItems,
    num? amountCost,
  }) {
    return AddProduct(
      userId: userId ?? this.userId,
      storeId: storeId ?? this.storeId,
      addProductItems: addProductItems ?? this.addProductItems,
      amountCost: amountCost ?? this.amountCost,
    );
  }
}
