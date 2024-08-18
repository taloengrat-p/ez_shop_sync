import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/_local/product_local_repository.dart';
import 'package:ez_shop_sync/flavors.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ProductLocalRepository, env: [Flavor.DEV, Flavor.PROD])
@Injectable(as: ProductLocalRepository, env: [Flavor.DEV, Flavor.PROD])
class ProductLocalDevRepository extends BaseHiveRepository<String, Product> implements ProductLocalRepository {
  ProductLocalDevRepository({
    required super.hiveDBService,
  });
  @override
  Future<Product> create(Product request) async {
    final now = DateTime.now();

    var product = request
      ..createDate = now
      ..updateDate = now;

    final id = await hiveDBService.productBox.add(
      request
        ..createDate = now
        ..updateDate = now,
    );

    hiveDBService.productBox.put(id, product..id = id.toString());

    return product..id = id.toString();
  }

  @override
  delete(String id) {
    hiveDBService.productBox.delete(int.parse(id));
  }

  @override
  deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  List<Product> getAll() {
    return hiveDBService.productBox.values.toList();
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
