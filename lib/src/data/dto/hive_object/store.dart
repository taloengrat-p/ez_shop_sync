import 'package:hive/hive.dart';

import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:ez_shop_sync/src/theme/app_theme.dart';

part 'store.g.dart';

@HiveType(typeId: 3)
class Store extends BaseHiveObject {
  @HiveField(7)
  String ownerId;

  @HiveField(8)
  String name;

  @HiveField(9)
  String? address;

  @HiveField(10)
  List<String>? phoneNumbers;

  @HiveField(11)
  String? email;

  @HiveField(12)
  String? website;

  @HiveField(13)
  String? description;

  @HiveField(14)
  List<String>? images;

  @HiveField(15, defaultValue: [])
  List<String>? tags;

  @HiveField(16, defaultValue: null)
  AppTheme? storeTheme;

  @HiveField(17, defaultValue: [])
  List<String>? categories;

  Store({
    required super.id,
    super.createDate,
    super.createBy,
    super.updateDate,
    super.updateBy,
    required this.ownerId,
    required this.name,
    this.address,
    this.phoneNumbers,
    this.email,
    this.website,
    this.description,
    this.images,
    this.tags,
    this.storeTheme,
    this.categories,
  });

  @override
  String toString() {
    return 'Store(ownerId: $ownerId, name: $name, address: $address, phoneNumbers: $phoneNumbers, email: $email, website: $website, description: $description, images: $images, tags: $tags, storeTheme: $storeTheme, categories: $categories)';
  }
}
