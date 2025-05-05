import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user_data.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class AuthLocalRepository extends BaseHiveRepository<String, UserData> {
  AuthLocalRepository() : super(boxName: HiveBoxConstance.user);

  UserData? getByUsername(String username) {
    return null;
  }
}
