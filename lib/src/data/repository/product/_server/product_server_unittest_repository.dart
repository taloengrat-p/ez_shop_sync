import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/product/_server/product_server_repository.dart';
import 'package:ez_shop_sync/flavors.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ProductServerRepository, env: [Flavor.TESTS])
class ProductServerUnittestRepository implements ProductServerRepository {
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
  deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  List<Product> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Product getDetail(String id) {
    // TODO: implement getDetail
    throw UnimplementedError();
  }

  @override
  Product update(String id, Product updated) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
