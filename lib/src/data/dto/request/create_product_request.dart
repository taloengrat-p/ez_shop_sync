import 'dart:io';

import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';

class CreateProductRequest {
  final Product product;
  final File? image;

  CreateProductRequest({required this.product, required this.image});
}
