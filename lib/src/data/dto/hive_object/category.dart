import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 7)
class Category extends BaseHiveObject {
  @HiveField(7)
  String name;

  @HiveField(8, defaultValue: null)
  String? parentId;

  @HiveField(9)
  String? color;

  @HiveField(10)
  String? borderColor;

  @HiveField(11)
  Map<String, dynamic>? iconData;

  Category({
    required this.name,
    required super.id,
    this.parentId,
    this.borderColor,
    this.color,
    this.iconData,
  });
}
