import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/models/base_object.dart';
import 'package:hive/hive.dart';

abstract class BaseHiveObject extends BaseObject {
  @HiveField(1)
  dynamic id;

  @HiveField(2)
  BaseHiveData? info;

  BaseHiveObject({this.id, this.info});
}
