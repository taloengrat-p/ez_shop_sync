import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
@Singleton()
class StoreLocalRepository extends BaseHiveRepository<String, Store> {
  StoreLocalRepository() : super(boxName: HiveBoxConstance.store);
}
