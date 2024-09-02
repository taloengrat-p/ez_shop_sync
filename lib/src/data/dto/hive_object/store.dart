import 'package:hive/hive.dart';

import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:ez_shop_sync/src/theme/app_theme.dart';

part 'store.g.dart';

@HiveType(typeId: 3)
class Store extends BaseHiveObject {
  @HiveField(6)
  String ownerId;

  @HiveField(7)
  String name;

  @HiveField(8)
  String? address;

  @HiveField(9)
  List<String>? phoneNumbers;

  @HiveField(10)
  String? email;

  @HiveField(11)
  String? website;

  @HiveField(12)
  String? description;

  @HiveField(13)
  List<String>? images;

  @HiveField(14, defaultValue: [])
  List<String>? tags;

  @HiveField(15, defaultValue: null)
  AppTheme? storeTheme;

  @HiveField(16, defaultValue: [])
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
