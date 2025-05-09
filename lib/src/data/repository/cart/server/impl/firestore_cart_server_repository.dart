import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/data/repository/cart/server/i_cart_server_repository.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ICartServerRepository, env: [Flavor.DEV, Flavor.STG, Flavor.PROD])
class FirestoreCartServerRepository implements ICartServerRepository {}
