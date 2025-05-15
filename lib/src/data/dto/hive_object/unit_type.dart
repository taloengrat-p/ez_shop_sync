// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:ez_shop_sync/src/data/dto/hive_object/string_locale.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';

part 'unit_type.g.dart';

@HiveType(typeId: 20)
@JsonSerializable(explicitToJson: true)
class UnitType extends BaseHiveObject {
  @HiveField(3)
  final StringLocale name;

  @HiveField(4)
  final StringLocale shortName;

  UnitType({required this.name, super.info, super.id, required this.shortName});

  factory UnitType.fromJson(Map<String, dynamic> json) => _$UnitTypeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UnitTypeToJson(this);

  UnitType copyWith({String? id, StringLocale? name, BaseHiveData? info, StringLocale? shortName}) {
    return UnitType(
      id: id ?? super.id,
      name: name ?? this.name,
      info: info ?? super.info,
      shortName: shortName ?? this.shortName,
    );
  }
}
