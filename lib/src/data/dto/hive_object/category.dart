// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: type_init_formals

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';

part 'category.g.dart';

@HiveType(typeId: 7)
@JsonSerializable(explicitToJson: true)
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
    super.id,
    BaseHiveData? super.info,
    required this.name,
    this.parentId,
    this.borderColor,
    this.color,
    this.iconData,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  Category copyWith({
    String? id,
    String? name,
    String? parentId,
    String? color,
    String? borderColor,
    Map<String, dynamic>? iconData,
    BaseHiveData? info,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      color: color ?? this.color,
      borderColor: borderColor ?? this.borderColor,
      iconData: iconData ?? this.iconData,
      info: info ?? this.info,
    );
  }
}
