import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';

class AddProductRequest {
  String id;
  Product product;
  AddProductRequest({required this.id, required this.product});
}
