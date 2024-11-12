// ignore_for_file: type_init_formals

import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_group.g.dart';

@HiveType(typeId: 16)
@JsonSerializable(explicitToJson: true)
class ProductGroup extends BaseHiveObject {
  ProductGroup({
    super.id,
    BaseHiveData? super.info,
  });

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
