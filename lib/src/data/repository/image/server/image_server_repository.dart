import 'package:ez_shop_sync/flavors.dart';
import 'package:injectable/injectable.dart';

@Singleton(env: [Flavor.DEV])
class ImageServerRepository {}
