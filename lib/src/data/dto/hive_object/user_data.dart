import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@HiveType(typeId: 4)
@JsonSerializable(explicitToJson: true)
class UserData extends BaseHiveObject {
  @HiveField(7)
  final String uid;
  @HiveField(8, defaultValue: null)
  final String? storeSelected;
  @HiveField(9, defaultValue: [])
  final List<String>? stores;
  @HiveField(10)
  final String? displayName;
  UserData({
    required super.id,
    super.createDate,
    super.createBy,
    super.updateDate,
    super.updateBy,
    required this.uid,
    this.storeSelected,
    this.stores,
    this.displayName,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
