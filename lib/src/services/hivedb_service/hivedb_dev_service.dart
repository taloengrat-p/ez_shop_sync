import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/services/hivedb_service/hivedb_service.dart';
import 'package:injectable/injectable.dart';

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
