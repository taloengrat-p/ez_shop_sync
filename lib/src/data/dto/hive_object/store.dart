import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:hive/hive.dart';

part 'store.g.dart';

@HiveType(typeId: 3)
class Store extends BaseHiveObject {
  @HiveField(2)
  String ownerId;

  @HiveField(3)
  String name;

  @HiveField(4)
  String? address;

  @HiveField(5)
  List<String>? phoneNumbers;

  @HiveField(6)
  String? email;

  @HiveField(7)
  String? website;

  @HiveField(8)
  String? description;

  @HiveField(9)
  List<String>? images;

  Store({
    required super.id,
    required this.ownerId,
    required this.name,
    this.address,
    this.phoneNumbers,
    this.email,
    this.website,
    this.description,
    this.images,
  });
}
