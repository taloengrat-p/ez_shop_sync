import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';

abstract class StoreLocalRepository {
  Future<ApiResult<Store>> create(BaseRepoRequest<Store> request);
  Future<ApiResult> delete(String request);
  Future<ApiResult> deleteAllByIds(List<String> ids);
  Future<ApiResult<Store>> getById(String request);
  Future<ApiResult<Store>> update(BaseRepoRequest<Store> request);
  Future<ApiResult<List<Store>>> getAllByIds(List<String> ids);
}
