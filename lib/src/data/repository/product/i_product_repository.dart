// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_request.dart';

abstract class IProductRepository {
  Future<ApiResult<Product>> createProduct(BaseRepoRequest<CreateProductRequest> request);
  Future<ApiResult<Product>> updateProduct(BaseRepoRequest<UpdateProductImageRequest> request);
  Future<ApiResult> deleteProduct(BaseRepoRequest<Product> request);
}

class CreateProductImageRequest {
  final Product product;
  final File? image;

  CreateProductImageRequest({required this.product, this.image});
}

class UpdateProductImageRequest {
  final String imageRefUrl;
  final File? updatedImage;
  Product? product;
  UpdateProductImageRequest({required this.imageRefUrl, this.updatedImage, required this.product});
}
