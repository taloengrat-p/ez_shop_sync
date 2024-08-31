import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/_local/product_local_repository.dart';
import 'package:ez_shop_sync/flavors.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ProductLocalRepository, env: [Flavor.DEV, Flavor.PROD])
@Injectable(as: ProductLocalRepository, env: [Flavor.DEV, Flavor.PROD])
class ProductLocalDevRepository extends BaseHiveRepository<String, Product>
    implements ProductLocalRepository {
  ProductLocalDevRepository() : super(boxName: HiveBoxConstance.product);

  @override
  List<Product> getAllByStoreId(String id) {
    return getAll().where((e) => e.storeId == id).toList();
  }
}
