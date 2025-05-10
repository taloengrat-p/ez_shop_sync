import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/pagination_index_request.dart';
import 'package:ez_shop_sync/src/data/dto/response/add_product_history_response.dart';

abstract class IAddProductHistoryServerRepository {
  Future<ApiResult<AddProduct>> createAddProductHistory(BaseRepoRequest<AddProduct> request);
  Future<ApiResult<AddProductHistoryResponse>> getItemsByLimit(BaseRepoRequest<PaginationIndexRequest> request);

  Future<ApiResult<AddProduct>> getDetailById(BaseRepoRequest<String> request);
}
