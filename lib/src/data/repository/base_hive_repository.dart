import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/services/hivedb_service/hivedb_service.dart';
import 'package:hive/hive.dart';

class BaseHiveRepository<I, T extends Object> {
  HiveDBService hiveDBService;

  BaseHiveRepository({
    required this.hiveDBService,
  });

  T? getById(I id) {
    // Implement fetching logic here

    if (T is Box<Product>) {
      return hiveDBService.productBox.get(id) as T;
    }

    return null;
  }

  List<T> getAll() {
    // Implement fetching logic here
    if (T is Box<Product>) {
      return hiveDBService.productBox.values as List<T>;
    }

    return [];
  }
}
