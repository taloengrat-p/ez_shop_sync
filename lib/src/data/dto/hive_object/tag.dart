import 'package:hive/hive.dart';

import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';

part 'tag.g.dart';

@HiveType(typeId: 5)
class Tag extends BaseHiveObject {
  @HiveField(7)
  final String name;

  @HiveField(8)
  final String? color;

  @HiveField(9)
  final String? borderColor;

  Tag({
    required super.id,
    required this.name,
    this.color,
    this.borderColor,
  });

  @override
  String toString() => 'Tag(name: $name, color: $color, borderColor: $borderColor)';
}
