import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class UserRepository extends BaseHiveRepository<String, User> {
  UserRepository() : super(boxName: HiveBoxConstance.user);
}
