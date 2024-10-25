import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_order.g.dart';

@HiveType(typeId: 12)
@JsonSerializable()
class ProductOrder extends BaseHiveObject {
  @HiveField(7)
  final String status;

  @HiveField(8)
  final String paymentType;

  @HiveField(9, defaultValue: [])
  List<OrderItem> cartItems;

  ProductOrder({
    required super.id,
    required this.status,
    required this.cartItems,
    required this.paymentType,
  });

  factory ProductOrder.fromJson(Map<String, dynamic> json) => _$ProductOrderFromJson(json);

  Map<String, dynamic> toJson() => _$ProductOrderToJson(this);
}
