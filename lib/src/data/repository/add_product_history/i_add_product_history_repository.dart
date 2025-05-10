import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_add_stock_request.dart';

abstract class IAddProductHistoryRepository {
  List<AddProduct> getAllByIds(List<String> ids);
  Future<AddProduct> create(CreateAddProductRequest request);
  Future<AddProduct> update(String id, AddProduct updated);
  Future<void> delete(String id);
  Future<void> deleteAll(List<String> ids);
  Future<ApiResult<AddProduct>> getDetailById(BaseRepoRequest<String> request);
}
