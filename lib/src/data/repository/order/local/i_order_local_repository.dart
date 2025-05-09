import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';

abstract class IOrderLocalRepository {
  Future<ApiResult<ProductOrder>> create(BaseRepoRequest<ProductOrder> request);
  Future<ApiResult> delete(String request);
  deleteAllByIds(List<String> ids);
  Future<ApiResult<List<ProductOrder>>> getAll();
  List<ProductOrder> getAllRange(int start, int end);
  Future<ApiResult<ProductOrder>> getById(String request);
  Future<ApiResult<ProductOrder>> update(BaseRepoRequest<ProductOrder> request);
  Future<ApiResult<List<ProductOrder>>> getAllBetween({required DateTime start, required DateTime end});
  Future<ApiResult<List<ProductOrder>>> getAllByIds(List<String> ids);
}
