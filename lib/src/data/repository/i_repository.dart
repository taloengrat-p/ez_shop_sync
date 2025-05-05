import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';

abstract class IRepository<T> {
  AppMode appMode;

  IRepository(this.appMode);
  Future<ApiResult<List<T>>> getAll();
  Future<ApiResult<List<T>>> getAllByIds(List<String> ids);
  Future<ApiResult<T>> getById(BaseRepoRequest<String> id);
  Future<ApiResult<T>> create(BaseRepoRequest<T> request);
  Future<ApiResult<T>> update(BaseRepoRequest<T> request);
  Future<ApiResult> delete(BaseRepoRequest<String> request);
  Future<ApiResult> deleteAllByIds(List<String> ids);
  Future<ApiResult> deleteAll();
}
