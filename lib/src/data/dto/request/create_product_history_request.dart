import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/product_history_event.enum.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_product_history_request.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateProductHistoryRequest extends BaseRepoRequest<ProductHistoryEvent> {
  String productId;
  String? productTypeId;
  Map<String, dynamic>? oldData;
  Map<String, dynamic>? newData;
  String? refId;
  String? addStockId;

  CreateProductHistoryRequest({
    required super.branchId,
    required super.storeId,
    this.productTypeId,
    required super.userId,
    required this.productId,
    required super.data,
    this.newData,
    this.oldData,
    required super.info,
    this.addStockId,
    this.refId,
  });

  factory CreateProductHistoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProductHistoryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateProductHistoryRequestToJson(this);
}
