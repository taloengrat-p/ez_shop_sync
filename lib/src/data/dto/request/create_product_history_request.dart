import 'package:ez_shop_sync/src/data/dto/hive_object/enums/product_history_event.enum.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';

class CreateProductHistoryRequest extends BaseRepoRequest {
  String productId;
  ProductHistoryEvent event;
  Map<String, dynamic>? oldData;
  Map<String, dynamic>? newData;

  CreateProductHistoryRequest({
    required super.id,
    required super.storeId,
    required super.userId,
    required this.productId,
    required this.event,
    this.newData,
    this.oldData,
  });
}
