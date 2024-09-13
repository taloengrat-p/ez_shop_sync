import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';
import 'package:ez_shop_sync/src/services/hivedb_service/hivedb_service.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: HiveDBService, env: [Flavor.TESTS])
@Injectable(as: HiveDBService, env: [Flavor.TESTS])
class HiveDBUnittestService extends HiveDBService {
  @override
  init() {
    throw UnimplementedError();
  }

  @override
  initBox() {
    throw UnimplementedError();
  }

  @override
  registerAdapter() {
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(ProductStatusAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(StoreAdapter());
  }
}
