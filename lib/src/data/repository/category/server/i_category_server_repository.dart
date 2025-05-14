import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';

abstract class ICategoryServerRepository {
  Future<ApiResult<Category>> create(BaseRepoRequest<Category> request);

  Future<ApiResult<List<Category>>> getCategoryByStoreId(BaseRepoRequest<Null> request);

  Future<ApiResult> deleteCategoryByIds(BaseRepoRequest<List<String>> request);

  Future<ApiResult> update(BaseRepoRequest<Category> request);
}
