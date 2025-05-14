import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/category/local/i_category_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/category/server/i_category_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class CategoryRepository {
  final ICategoryLocalRepository categoryLocalRepository;
  final ICategoryServerRepository categoryServerRepository;
  AppMode appMode = AppMode.server;

  CategoryRepository({required this.categoryLocalRepository, required this.categoryServerRepository});

  Future<ApiResult<Category>> create(BaseRepoRequest<Category> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return await categoryServerRepository.create(request);
    }
  }

  Future<ApiResult> getCategoryByStoreId(BaseRepoRequest<Null> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return await categoryServerRepository.getCategoryByStoreId(request);
    }
  }

  Future<ApiResult> deleteCategoryByIds(BaseRepoRequest<List<String>> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return await categoryServerRepository.deleteCategoryByIds(request);
    }
  }

  Future<ApiResult> update(BaseRepoRequest<Category> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return await categoryServerRepository.update(request);
    }
  }
}
