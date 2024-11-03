import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_add_stock_request.dart';
import 'package:ez_shop_sync/src/data/repository/add_product/add_product_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/add_product/add_product_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/base_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';

abstract class IAddProductRepository {
  List<AddProduct> getAddProductByUserIdWithCurrentStore(List<String> request);
  Future<AddProduct> create(CreateAddProductRequest request);
  Future<AddProduct> update(String id, AddProduct updated);
  Future<void> delete(String id);
  Future<void> deleteAll(List<String> ids);
}

@Singleton()
@Injectable()
class AddProductRepository extends BaseRepository implements IAddProductRepository {
  AddProductLocalRepository addProductLocalRepository;
  AddProductServerRepository addProductServerRepository;

  AddProductRepository({
    required this.addProductLocalRepository,
    required this.addProductServerRepository,
  });

  @override
  Future<AddProduct> create(CreateAddProductRequest request) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.createIfNotExist(request);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> delete(String id) async {
    if (appMode == AppMode.local) {
      await addProductLocalRepository.delete(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> deleteAll(List<String> ids) async {
    if (appMode == AppMode.local) {
      await addProductLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  List<AddProduct> getAddProductByUserIdWithCurrentStore(List<String> carts) {
    if (appMode == AppMode.local) {
      return addProductLocalRepository.getAllById(carts);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<AddProduct> update(String id, AddProduct updated) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.update(id, updated);
    } else {
      throw UnimplementedError();
    }
  }

  Future<AddProduct> deleteItemByIdFromCart(String? id, String addProductItemId) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.deleteItemByIdFromCart(id, addProductItemId);
    } else {
      throw UnimplementedError();
    }
  }

  Future<AddProduct?> addProduct(String id, Product product) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.addProduct(id, product);
    } else {
      throw UnimplementedError();
    }
  }

  Future<void> increaseQty(String? cartId, String? productId, num qty) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.increaseQty(cartId, productId, qty);
    } else {
      throw UnimplementedError();
    }
  }

  Future<void> decreaseQty(String? cartId, String? productId, num qty) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.decreaseQty(cartId, productId, qty);
    } else {
      throw UnimplementedError();
    }
  }
}
