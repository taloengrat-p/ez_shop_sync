import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';

class AddProductQtyToStockrequest extends BaseRepoRequest<Product> {
  final num amountCost;
  final String productId;

  AddProductQtyToStockrequest({
    required super.storeId,
    required super.userId,
    required super.data,
    required this.amountCost,
    required this.productId,
  });
}
