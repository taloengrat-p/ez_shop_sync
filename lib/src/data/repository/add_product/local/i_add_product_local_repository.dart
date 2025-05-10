import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/add_product_decrease_qty_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/add_product_increase_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/add_product_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/delete_item_form_cart_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';

abstract class IAddProductLocalRepository {
  Future<ApiResult<List<AddProduct>>> getByUserIdWithCurrentStore(List<String> addProductsId);

  Future<ApiResult<AddProduct>> deleteItemByIdFromCart(BaseRepoRequest<DeleteItemFormCartRequest> request);

  Future<ApiResult<AddProduct>> addProductStock(BaseRepoRequest<AddProductStockRequest> request);

  Future<ApiResult> increaseQty(BaseRepoRequest<AddProductIncreaseRequest> request);

  Future<ApiResult> decreaseQty(BaseRepoRequest<AddProductDecreaseQtyRequest> request);

  Future<ApiResult<AddProduct>> createIfNotExist(BaseRepoRequest<AddProduct> request);

  Future<ApiResult> delete(String request);

  Future<ApiResult> deleteAllByIds(List<String> ids);

  Future<ApiResult<List<AddProduct>>> getAddProductByUserIdWithCurrentStore(BaseRepoRequest addProduct);

  Future<ApiResult<AddProduct>> update(BaseRepoRequest<AddProduct> request);

  Future<ApiResult<List<AddProduct>>> getAll();

  Future<ApiResult<List<AddProduct>>> getAllByIds(List<String> ids);

  Future<ApiResult<AddProduct>> getById(String request);

  Future<ApiResult> deleteAll();
}
