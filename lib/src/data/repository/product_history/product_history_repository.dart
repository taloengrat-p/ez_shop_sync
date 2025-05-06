import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_history.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_history_request.dart';
import 'package:ez_shop_sync/src/data/repository/i_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product_history/local/product_history_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product_history/server/product_history_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';

abstract class IProductHistoryRepository {
  Future<List<ProductHistory>> getAllByProductId(String id, {AppMode appMode = AppMode.local});
  Future<ProductHistory> create(CreateProductHistoryRequest request);
  Future<void> delete(String id, {AppMode appMode = AppMode.local});
  Future<void> deleteAll(BaseRepoRequest request);
}

@Singleton()
@Injectable()
class ProductHistoryRepository extends IRepository<ProductHistory> {
  ProductHistoryLocalRepository productHistoryLocalRepository;
  ProductHistoryServerRepository productHistoryServerRepository;
  ProductHistoryRepository({
    required this.productHistoryLocalRepository,
    required this.productHistoryServerRepository,
    required super.navigationService,
  }) : super(AppMode.local);

  @override
  Future<ApiResult<ProductHistory>> create(BaseRepoRequest<ProductHistory> request) async {
    if (appMode == AppMode.local) {
      return await productHistoryLocalRepository.create(request);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> delete(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      return await productHistoryLocalRepository.delete(request.data);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> deleteAllByIds(List<String> ids) async {
    if (appMode == AppMode.local) {
      return await productHistoryLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult<List<ProductHistory>>> getAllByProductId(String id) async {
    if (appMode == AppMode.local) {
      return productHistoryLocalRepository.getByProductId(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<ProductHistory>>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<List<ProductHistory>>> getAllByIds(List<String> ids) {
    // TODO: implement getAllByIds
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<ProductHistory>> getById(BaseRepoRequest<String> id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<ProductHistory>> update(BaseRepoRequest<ProductHistory> request) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<ApiResult> deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }
}
