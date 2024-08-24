import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';
import 'package:ez_shop_sync/src/services/hivedb_service/hivedb_service.dart';
import 'package:injectable/injectable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

@Singleton(as: HiveDBService, env: [Flavor.DEV, Flavor.PROD])
@Injectable(as: HiveDBService, env: [Flavor.DEV, Flavor.PROD])
class HiveDBDevService extends HiveDBService {
  HiveDBDevService() {
    init();
  }

  @override
  init() async {
    // final document = await getApplicationDocumentsDirectory();
    // await Hive.initFlutter(document.path);
    // registerAdapter();
    // await initBox();
  }

  @override
  initBox() async {
    // super.productBox = await Hive.openBox<Product>(HiveBoxConstance.product);
  }

  @override
  registerAdapter() {
    // Hive.registerAdapter(ProductAdapter());
    // Hive.registerAdapter(ProductStatusAdapter());
  }
}
