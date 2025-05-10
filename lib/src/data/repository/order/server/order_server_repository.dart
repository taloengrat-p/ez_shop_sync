import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_order_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/pagination_index_request.dart';
import 'package:ez_shop_sync/src/data/dto/response/order_history_reponse.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';

abstract class IOrderServerRepository {
  Future<ApiResult<ProductOrder>> createOrder(BaseRepoRequest<CreateOrderRequest> request);

  Future<ApiResult<OrderHistoryResponse>> getOrderHistoryList(BaseRepoRequest<PaginationIndexRequest> request);

  Future<ApiResult<ProductOrder>> getOrderHistory(BaseRepoRequest<String> request);

  Future<ApiResult<List<ProductOrder>>> getByDatetime(BaseRepoRequest<OrderGetByDateRangeRequest> request);
}
