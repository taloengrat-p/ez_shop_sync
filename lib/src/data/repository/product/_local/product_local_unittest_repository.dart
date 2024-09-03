import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/product/_local/product_local_repository.dart';
import 'package:ez_shop_sync/flavors.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProductLocalRepository, env: [Flavor.TESTS])
class ProductLocalUnittestRepository implements ProductLocalRepository {
  @override
  Future<Product> create(Product request) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  List<Product> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Product? getById(String id) {
    // TODO: implement getDetail
    throw UnimplementedError();
  }

  @override
  Future<Product> update(String id, Product updated) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  List<Product> getAllByStoreId(String id) {
    // TODO: implement getAllByStoreId
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAll(List<String> ids) {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }
}
