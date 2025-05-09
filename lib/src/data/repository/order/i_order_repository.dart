import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_order_request.dart';

abstract class IOrderRepository {
  Future<ApiResult> createFromCart(BaseRepoRequest<CreateOrderRequest> request);
}
