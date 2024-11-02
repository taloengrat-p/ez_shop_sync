import 'package:ez_shop_sync/src/models/base_object.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_config.g.dart';

@HiveType(typeId: 13)
@JsonSerializable()
class ProductConfig extends BaseObject {
  @HiveField(1)
  bool enabled;

  ProductConfig({
    required this.enabled,
  });

  factory ProductConfig.fromJson(Map<String, dynamic> json) => _$ProductConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProductConfigToJson(this);
}
