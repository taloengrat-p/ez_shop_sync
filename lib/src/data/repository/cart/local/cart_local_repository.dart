import 'dart:developer';

import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:ez_shop_sync/src/data/repository/cart/cart_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@Singleton()
@Injectable()
class CartLocalRepository extends BaseHiveRepository<String, Cart> {
  CartLocalRepository() : super(boxName: HiveBoxConstance.cart);

  Future<ApiResult<List<Cart>>> getByUserIdWithCurrentStore(List<String> cartsId) {
    return getAllById(cartsId);
  }

  Future<ApiResult<Cart>> deleteItemByIdFromCart(BaseRepoRequest<DeleteItemFromCartRequest> request) async {
    if (request.data.id == null) {
      throw ('id is Null');
    }

    final result = await getById(request.data.id!);

    return result.when(
      success: (response) async {
        return await update(
          BaseRepoRequest(
            storeId: request.storeId,
            userId: request.userId,
            data: response..cartItems.removeWhere((item) => item.id == request.data.cartItemId),
          ),
        );
      },
      failure: (error) {
        return ApiResult(error: 'Cart get By id ${request.data.id} is Null');
      },
    );
  }

  Future<ApiResult<Cart>> addCart(BaseRepoRequest<AddCartRequest> request) async {
    log('addCart id ${request.data.id}');
    final cartResult = await getById(request.data.id);

    cartResult.when(
      success: (response) async {
        final productExistInCart = response.cartItems.any(
          (item) =>
              item.product?.id == request.data.product.id &&
              item.product?.priceSelected == request.data.product.priceSelected,
        );

        if (productExistInCart) {
          return await update(
            BaseRepoRequest(
              storeId: request.storeId,
              userId: request.userId,
              data:
                  response
                    ..cartItems =
                        response.cartItems
                            .map(
                              (OrderItem item) =>
                                  item.product?.id == request.data.product.id
                                      ? item.copyWith(
                                        product: item.product?.copyWith(
                                          quantity:
                                              (item.product?.quantity ?? 0) + (request.data.product.quantity ?? 0),
                                        ),
                                      )
                                      : item,
                            )
                            .toList(),
            ),
          );
        } else {
          return await update(
            BaseRepoRequest(
              storeId: request.storeId,
              userId: request.userId,
              data: response..cartItems.add(OrderItem(id: const Uuid().v1(), product: request.data.product)),
            ),
          );
        }
      },
      failure: (error) {
        return Future.value(ApiResult(error: 'Cart by ${request.data.id} is Null'));
      },
    );
    return Future.value(ApiResult(error: 'Cart by ${request.data.id} is Null'));
  }

  Future<ApiResult> increaseQty(BaseRepoRequest<CartIncreaseQtyRequest> request) async {
    log('[performRepo] increaseQty : ');
    if (request.data.cartId == null) {
      throw ('increaseQty() cartId is Null');
    }
    final cart = await getById(request.data.cartId!);

    cart.when(
      success: (response) async {
        final cartItem =
            response.cartItems
                .map(
                  (e) =>
                      e.id == request.data.productId
                          ? e.copyWith(product: e.product?.copyWith(quantity: (e.product?.quantity ?? 0)))
                          : e,
                )
                .toList();

        await update(
          BaseRepoRequest(storeId: request.storeId, userId: request.userId, data: response..cartItems = cartItem),
        );
      },
      failure: (error) {
        return Future.value(ApiResult(error: 'increaseQty() cart is Null'));
      },
    );

    return Future.value(ApiResult(error: 'increaseQty() cart is Null'));
  }

  Future<ApiResult> decreaseQty(
    String? cartId,
    String? productId,
    num qty, {
    required String storeId,
    required String userId,
  }) async {
    log('[performRepo] decreaseQty : ');
    if (cartId == null) {
      throw ('increaseQty() cartId is Null');
    }
    final cartResult = await getById(cartId);

    cartResult.when(
      success: (response) async {
        final cartItem =
            response.cartItems
                .map(
                  (e) =>
                      e.id == productId
                          ? e.copyWith(product: e.product?.copyWith(quantity: (e.product?.quantity ?? 0)))
                          : e,
                )
                .toList();

        await update(BaseRepoRequest(storeId: storeId, userId: userId, data: response..cartItems = cartItem));
      },
      failure: (error) {
        return Future.value(ApiResult(error: 'increaseQty() cart is Null'));
      },
    );

    return Future.value(ApiResult(error: 'increaseQty() cart is Null'));
  }

  Future<ApiResult<Cart>> getCartByStoreAndUserId({required String storeId, required String userId}) async {
    log('getCartByStoreAndUserId() : request $storeId, $userId');
    final allResult = await getAll();

    log('getCartByStoreAndUserId() : allCart ${allResult.response?.map((e) => {e.id, e.userId})}');
    return allResult.when(
      success: (response) async {
        final result = response.where((e) => e.storeId == storeId && e.userId == userId).firstOrNull;
        log('getCartByStoreAndUserId() : result $result');

        return ApiResult(response: result);
      },
      failure: (error) async {
        return ApiResult(error: 'getCartByStoreAndUserId : $error');
      },
    );
  }
}
