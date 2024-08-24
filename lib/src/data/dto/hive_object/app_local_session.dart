import 'package:hive/hive.dart';

import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';

part 'app_local_session.g.dart';

@HiveType(typeId: 5)
class AppLocalSession {
  @HiveField(1)
  final User? user;

  AppLocalSession({
    this.user,
  });
}
