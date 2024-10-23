import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart' as hiveType;
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class OrderLocalRepository extends BaseHiveRepository<String, hiveType.ProductOrder> {
  OrderLocalRepository() : super(boxName: HiveBoxConstance.order);

  // List<hiveType.Order> getAllByStoreId(String id) {
  //   return getAll().where((e) => e. == id).toList();
  // }
}
