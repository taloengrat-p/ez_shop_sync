import 'dart:io';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';

class CreateProductImageRequest {
  final Product product;
  final File? image;

  CreateProductImageRequest({required this.product, this.image});
}
