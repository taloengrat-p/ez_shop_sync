import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:hive/hive.dart';

abstract class HiveDBService {
  late Box<Product> productBox;

  init();

  initBox();

  registerAdapter();
}
