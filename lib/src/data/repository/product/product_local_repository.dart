import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class ProductLocalRepository extends BaseHiveRepository<String, Product> {
  ProductLocalRepository() : super(boxName: HiveBoxConstance.product);

  List<Product> getAllByStoreId(String id) {
    return getAll().where((e) => e.storeId == id).toList();
  }
}
