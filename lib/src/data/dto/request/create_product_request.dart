import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';

class CreateProductRequest extends BaseRepoRequest {
  Product product;

  CreateProductRequest({
    required super.storeId,
    required super.userId,
    required this.product,
  });
}
