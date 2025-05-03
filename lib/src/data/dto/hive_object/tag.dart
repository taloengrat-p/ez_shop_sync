// ignore_for_file: type_init_formals

import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:hive/hive.dart';

import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@HiveType(typeId: 5)
@JsonSerializable(explicitToJson: true)
class Tag extends BaseHiveObject {
  @HiveField(7)
  final String name;

  @HiveField(8)
  final String? color;

  @HiveField(9)
  final String? borderColor;

  Tag({
    super.id,
    BaseHiveData? super.info,
    required this.name,
    this.color,
    this.borderColor,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$TagToJson(this);
}
