import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:ez_shop_sync/src/data/repository/category/local/i_category_local_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ICategoryLocalRepository, env: [Flavor.DEV, Flavor.STG, Flavor.PROD])
class HivedbCategoryLocalRepository extends BaseHiveRepository<String, Category> implements ICategoryLocalRepository {
  HivedbCategoryLocalRepository() : super(boxName: HiveBoxConstance.category);
}
