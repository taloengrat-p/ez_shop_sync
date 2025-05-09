import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';

class AddCartRequest {
  String id;
  Product product;
  AddCartRequest({required this.id, required this.product});
}
