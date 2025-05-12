// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/member.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';

part 'branch.g.dart';

@HiveType(typeId: 19)
@JsonSerializable(explicitToJson: true)
class Branch extends BaseHiveObject {
  @HiveField(3)
  final String name;

  @HiveField(4)
  final List<Member> members;

  Branch({required this.name, super.info, super.id, required this.members});

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BranchToJson(this);
}
