import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';

class CreateAddProductRequest extends BaseRepoRequest {
  CreateAddProductRequest({required super.storeId, required super.userId, required super.data});
}
