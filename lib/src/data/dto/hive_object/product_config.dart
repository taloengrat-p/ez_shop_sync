import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

@HiveType(typeId: 13)
@JsonSerializable()
class ProductConfig {
  @HiveField(1)
  bool enabled;

  ProductConfig({
    required this.enabled,
  });
}
