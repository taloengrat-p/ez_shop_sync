import 'package:hive/hive.dart';

part 'store.g.dart';

@HiveType(typeId: 2)
class Store {
  @HiveField(1)
  String id;

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
    required this.id,
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
