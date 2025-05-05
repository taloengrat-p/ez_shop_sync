import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/add_product_history/server/add_product_history_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/i_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';

import 'local/add_product_history_local_repository.dart';

@Singleton()
@Injectable()
class AddProductHistoryRepository extends IRepository<AddProduct> {
  AddProductHistoryLocalRepository addProductHistoryLocalRepository;
  AddProductHistoryServerRepository addProductHistoryServerRepository;
  AddProductHistoryRepository({
    required this.addProductHistoryLocalRepository,
    required this.addProductHistoryServerRepository,
  }) : super(AppMode.local);

  @override
  Future<ApiResult<AddProduct>> create(BaseRepoRequest<AddProduct> request) async {
    if (appMode == AppMode.local) {
      return await addProductHistoryLocalRepository.create(request);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> delete(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      return await addProductHistoryLocalRepository.delete(request.data);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> deleteAllByIds(List<String> ids) async {
    if (appMode == AppMode.local) {
      return await addProductHistoryLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<AddProduct>>> getAllByIds(List<String> addProducts) async {
    if (appMode == AppMode.local) {
      return await addProductHistoryLocalRepository.getAllById(addProducts);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<AddProduct>> update(BaseRepoRequest<AddProduct> request) async {
    if (appMode == AppMode.local) {
      return await addProductHistoryLocalRepository.update(request);
    } else {
      throw UnimplementedError();
    }
  }

  List<AddProduct> getAllRange(int start, int end, {AppMode? appMode = AppMode.local}) {
    try {
      if (appMode == AppMode.local) {
        return addProductHistoryLocalRepository.getAllRange(start, end);
      } else {
        throw UnimplementedError();
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ApiResult<List<AddProduct>>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<AddProduct>> getById(BaseRepoRequest<String> request) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<ApiResult> deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }
}
