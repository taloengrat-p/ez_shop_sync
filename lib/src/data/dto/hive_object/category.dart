import 'package:hive/hive.dart';

import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';

part 'category.g.dart';

@HiveType(typeId: 7)
class Category extends BaseHiveObject {
  @HiveField(6)
  String name;

  @HiveField(7, defaultValue: null)
  String? parentId;

  Category({
    required this.name,
    required super.id,
    this.parentId,
  });
}
