import 'dart:io';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';

class UpdateProductImageRequest {
  final String imageRefUrl;
  final File? updatedImage;
  Product? product;
  UpdateProductImageRequest({required this.imageRefUrl, this.updatedImage, required this.product});
}
