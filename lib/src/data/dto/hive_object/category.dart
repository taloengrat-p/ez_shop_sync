import 'package:flutter/src/widgets/icon_data.dart';
import 'package:hive/hive.dart';

import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';

part 'category.g.dart';

@HiveType(typeId: 7)
class Category extends BaseHiveObject {
  @HiveField(6)
  String name;

  @HiveField(7, defaultValue: null)
  String? parentId;

  @HiveField(8)
  String? color;

  @HiveField(9)
  String? borderColor;

  @HiveField(10)
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
