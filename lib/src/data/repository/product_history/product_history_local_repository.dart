import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_history.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class ProductHistoryLocalRepository extends BaseHiveRepository<String, ProductHistory> {
  ProductHistoryLocalRepository()
      : super(
          boxName: HiveBoxConstance.productHistory,
        );

  Future<List<ProductHistory>> getByProductId(String id) {
    return Future.value(getAll().where((e) => e.productId == id).toList());
  }
}
