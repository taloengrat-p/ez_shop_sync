import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/local/store_local_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: StoreLocalRepository, env: [Flavor.DEV, Flavor.PROD, Flavor.STG])
@Singleton(as: StoreLocalRepository, env: [Flavor.DEV, Flavor.PROD, Flavor.STG])
class HivedbStoreLocalRepository extends BaseHiveRepository<String, Store> implements StoreLocalRepository {
  HivedbStoreLocalRepository() : super(boxName: HiveBoxConstance.store);
}
