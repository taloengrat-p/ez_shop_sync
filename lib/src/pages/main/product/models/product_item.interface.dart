import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';

abstract class IProductPage {
  onAddCart(Product product);
  onAddStock(Product product);
  onEdit(String productId);
  onDelete(String productId);
}
