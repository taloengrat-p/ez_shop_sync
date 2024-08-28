import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:hive/hive.dart';

part 'tag.g.dart';

@HiveType(typeId: 5)
class Tag extends BaseHiveObject {
  @HiveField(6)
  final String name;

  @HiveField(7)
  final String? color;

  Tag({
    required super.id,
    required this.name,
    this.color,
  });
}
