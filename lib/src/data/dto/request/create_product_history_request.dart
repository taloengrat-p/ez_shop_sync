import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/product_history_event.enum.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_product_history_request.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateProductHistoryRequest extends BaseRepoRequest {
  String productId;
  String? productTypeId;
  ProductHistoryEvent event;
  Map<String, dynamic>? oldData;
  Map<String, dynamic>? newData;
  BaseHiveData info;
  String? orderId;
  String? addStockId;

  CreateProductHistoryRequest({
    required super.storeId,
    this.productTypeId,
    required super.userId,
    required this.productId,
    required this.event,
    this.newData,
    this.oldData,
    required this.info,
    this.addStockId,
    this.orderId,
  });

  factory CreateProductHistoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProductHistoryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateProductHistoryRequestToJson(this);
}
