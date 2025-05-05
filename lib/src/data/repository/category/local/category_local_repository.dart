import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class CategoryLocalRepository extends BaseHiveRepository<String, Category> {
  CategoryLocalRepository() : super(boxName: HiveBoxConstance.category);
}
