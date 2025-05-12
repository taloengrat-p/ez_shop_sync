import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/cart_request/add_cart_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/cart_request/cart_decrease_qty_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/cart_request/cart_increase_qty_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/cart_request/delete_item_from_cart_request.dart';

abstract class ICartLocalRepository {
  Future<ApiResult<List<Cart>>> getByUserIdWithCurrentStore(List<String> cartsId);

  Future<ApiResult<Cart>> deleteItemByIdFromCart(BaseRepoRequest<DeleteItemFromCartRequest> request);

  Future<ApiResult<Cart>> addCart(BaseRepoRequest<AddCartRequest> request);

  Future<ApiResult> increaseQty(BaseRepoRequest<CartIncreaseQtyRequest> request);

  Future<ApiResult> decreaseQty(BaseRepoRequest<CartDecreaseQtyRequest> request);

  Future<ApiResult<Cart>> getCartByStoreAndUserId({required String storeId, required String userId});

  Future<ApiResult<Cart>> createIfNotExist(BaseRepoRequest<Cart> request);

  Future<ApiResult> delete(String request);

  Future<ApiResult> deleteAllByIds(List<String> ids);

  Future<ApiResult<Cart>> update(BaseRepoRequest<Cart> request);

  Future<ApiResult<List<Cart>>> getAll();

  Future<ApiResult<List<Cart>>> getAllByIds(List<String> ids);

  Future<ApiResult<Cart>> getById(String request);
}
