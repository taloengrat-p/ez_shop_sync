import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';

class CreateAddProductRequest extends BaseRepoRequest<AddProduct> {
  CreateAddProductRequest({
    required super.storeId,
    required super.userId,
    required super.data,
    required super.branchId,
  });
}
