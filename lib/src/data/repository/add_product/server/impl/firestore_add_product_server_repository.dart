import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/data/repository/add_product/server/i_add_product_server_repository.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IAddProductServerRepository, env: [Flavor.DEV, Flavor.PROD, Flavor.STG])
class FirestoreAddProductServerRepository implements IAddProductServerRepository {}
