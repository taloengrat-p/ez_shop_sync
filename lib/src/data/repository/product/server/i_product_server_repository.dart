import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_history.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_history_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/pagination_index_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/product_request/update_product_image_request.dart';
import 'package:ez_shop_sync/src/data/dto/response/pagination_response.dart';

abstract class IProductServerRepository {
  Future<ApiResult<Product>> createProduct(BaseRepoRequest<CreateProductRequest> request);

  Future<ApiResult<PaginationResponse<List<Product>>>> getAllByStoreAndBranchId(
    BaseRepoRequest<PaginationIndexRequest> request,
  );

  Future<ApiResult> delete(BaseRepoRequest<String> request);

  Future<ApiResult<Product>> update(BaseRepoRequest<Product> request);

  Future<ApiResult<Product>> getProduct({required String storeId, required String productId});

  Future<ApiResult<List<Product>>> getAllByIds({required String storeId, required List<String> productIds});

  Future<void> updateHistory(CreateProductHistoryRequest request);

  Future<void> reduceQuantity({
    required String storeId,
    required productId,
    String? productTypeId,
    required num reduceQty,
  });

  Future<ApiResult<List<ProductHistory>>> getProductHistory({required productId, required String storeId, int? limit});

  Future<ApiResult<Product>> updateProduct(BaseRepoRequest<UpdateProductImageRequest> request);

  Future<ApiResult> deleteProduct(BaseRepoRequest<Product> request);

  Future<void> addQuantity({
    required String storeId,
    required productId,
    String? productTypeId,
    required num reduceQty,
  });
}
