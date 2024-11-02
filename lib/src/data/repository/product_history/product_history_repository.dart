import 'package:ez_shop_sync/src/data/dto/hive_object/product_history.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_history_request.dart';
import 'package:ez_shop_sync/src/data/repository/product_history/product_history_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product_history/product_history_server_repository.dart';
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
class ProductHistoryRepository implements IProductHistoryRepository {
  ProductHistoryLocalRepository productHistoryLocalRepository;
  ProductHistoryServerRepository productHistoryServerRepository;

  ProductHistoryRepository({
    required this.productHistoryLocalRepository,
    required this.productHistoryServerRepository,
  });

  @override
  Future<ProductHistory> create(CreateProductHistoryRequest request) async {
    if (request.appMode == AppMode.local) {
      ProductHistory productHistory = ProductHistory(
        productId: request.productId,
        event: request.event.toString(),
        oldData: request.oldData,
        newData: request.newData,
      );
      return await productHistoryLocalRepository.create(
        productHistory,
        userId: request.userId,
      );
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> delete(String id, {AppMode appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      return await productHistoryLocalRepository.delete(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> deleteAll(BaseRepoRequest request) {
    if (request.appMode == AppMode.local) {
      return productHistoryLocalRepository.deleteAll();
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<List<ProductHistory>> getAllByProductId(String id, {AppMode appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      return productHistoryLocalRepository.getByProductId(id);
    } else {
      throw UnimplementedError();
    }
  }
}
