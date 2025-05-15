// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/product_request/update_product_image_request.dart';

abstract class IProductRepository {
  Future<ApiResult<Product>> createProduct(BaseRepoRequest<CreateProductRequest> request);
  Future<ApiResult<Product>> updateProduct(BaseRepoRequest<UpdateProductImageRequest> request);
  Future<ApiResult> deleteProduct(BaseRepoRequest<Product> request);
  Future<ApiResult<List<Product>>> searchProductByKey(BaseRepoRequest<String> request);
}
