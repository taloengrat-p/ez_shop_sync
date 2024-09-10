import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 9)
class CartItem extends BaseHiveObject {
  @HiveField(7)
  Product? product;

  CartItem({
    required super.id,
    required this.product,
  });
}
