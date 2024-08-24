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
  deleteAll(List<String> ids) {
    return ['1', '2', '3'];
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
  Product update(String id, Product updated) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
