import 'package:ez_shop_sync/src/models/base_object.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_theme.g.dart';

@HiveType(typeId: 6)
@JsonSerializable(explicitToJson: true)
class AppTheme extends BaseObject {
  @HiveField(1)
  String primaryColor;
  @HiveField(2)
  String secondaryColor;
  @HiveField(3)
  String accentColor;
  @HiveField(4)
  String backgroundColor;
  AppTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
  });

  factory AppTheme.fromJson(Map<String, dynamic> json) => _$AppThemeFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AppThemeToJson(this);
}
