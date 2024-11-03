import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_add_stock_request.dart';
import 'package:ez_shop_sync/src/data/repository/add_product_history/add_product_history_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/base_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';

import 'add_product_history_local_repository.dart';

abstract class IAddProductHistoryRepository {
  List<AddProduct> getAllByIds(List<String> ids);
  Future<AddProduct> create(CreateAddProductRequest request);
  Future<AddProduct> update(String id, AddProduct updated);
  Future<void> delete(String id);
  Future<void> deleteAll(List<String> ids);
}

@Singleton()
@Injectable()
class AddProductHistoryRepository extends BaseRepository implements IAddProductHistoryRepository {
  AddProductHistoryLocalRepository addProductHistoryLocalRepository;
  AddProductHistoryServerRepository addProductHistoryServerRepository;

  AddProductHistoryRepository({
    required this.addProductHistoryLocalRepository,
    required this.addProductHistoryServerRepository,
  });

  @override
  Future<AddProduct> create(CreateAddProductRequest request) async {
    if (appMode == AppMode.local) {
      return await addProductHistoryLocalRepository.create(
        request.addProduct,
        userId: request.userId,
      );
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> delete(String id) async {
    if (appMode == AppMode.local) {
      await addProductHistoryLocalRepository.delete(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> deleteAll(List<String> ids) async {
    if (appMode == AppMode.local) {
      await addProductHistoryLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  List<AddProduct> getAllByIds(List<String> addProducts) {
    if (appMode == AppMode.local) {
      return addProductHistoryLocalRepository.getAllById(addProducts);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<AddProduct> update(String id, AddProduct updated) async {
    if (appMode == AppMode.local) {
      return await addProductHistoryLocalRepository.update(id, updated);
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
}
