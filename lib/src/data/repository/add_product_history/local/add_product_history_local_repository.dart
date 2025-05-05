import 'dart:developer';

import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@Singleton()
@Injectable()
class AddProductHistoryLocalRepository extends BaseHiveRepository<String, AddProduct> {
  AddProductHistoryLocalRepository() : super(boxName: HiveBoxConstance.addProductHistory);

  Future<ApiResult<List<AddProduct>>> getByUserIdWithCurrentStore(List<String> addProductsId) async {
    return getAllById(addProductsId);
  }

  Future<ApiResult<AddProduct>> deleteItemByIdFromCart(
    String? id,
    String addProductItemId, {
    required String storeId,
    required String userId,
  }) async {
    if (id == null) {
      throw ('id is Null');
    }

    final result = await getById(id);

    result.when(
      success: (response) async {
        return await update(
          BaseRepoRequest(
            storeId: storeId,
            userId: userId,
            data: response..addProductItems.removeWhere((item) => item.id == addProductItemId),
          ),
        );
      },
      failure: (error) {
        return Future.value(ApiResult(error: 'Cart get By id $id is Null'));
      },
    );

    return Future.value(ApiResult(error: 'Cart get By id $id is Null'));
  }

  Future<ApiResult<AddProduct>> addProduct(
    String id,
    Product product, {
    required String storeId,
    required String userId,
  }) async {
    final addProductResult = await getById(id);

    addProductResult.when(
      success: (response) async {
        final productExistInCart = response.addProductItems.any(
          (item) => item.product?.id == product.id && item.product?.priceSelected == product.priceSelected,
        );

        if (productExistInCart) {
          return await update(
            BaseRepoRequest(
              storeId: storeId,
              userId: userId,
              data:
                  response
                    ..addProductItems =
                        response.addProductItems
                            .map(
                              (OrderItem item) =>
                                  item.product?.id == product.id
                                      ? item.copyWith(
                                        product: item.product?.copyWith(
                                          quantity: (item.product?.quantity ?? 0) + (product.quantity ?? 0),
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
              storeId: storeId,
              userId: userId,
              data: response..addProductItems.add(OrderItem(id: const Uuid().v1(), product: product)),
            ),
          );
        }
      },
      failure: (error) {
        return ApiResult(error: 'Cart by $id is Null');
      },
    );
    return ApiResult(error: 'Cart by $id is Null');
  }

  Future<ApiResult> increaseQty(
    String? addProductId,
    String? productId,
    num qty, {
    required String storeId,
    required String userId,
  }) async {
    log('[performRepo] increaseQty : ');
    if (addProductId == null) {
      throw ('increaseQty() addProductId is Null');
    }
    final addProductResult = await getById(addProductId);

    addProductResult.when(
      success: (response) async {
        final addProductItem =
            response.addProductItems
                .map(
                  (e) =>
                      e.id == productId
                          ? e.copyWith(product: e.product?.copyWith(quantity: (e.product?.quantity ?? 0)))
                          : e,
                )
                .toList();

        await update(
          BaseRepoRequest(storeId: storeId, userId: userId, data: response..addProductItems = addProductItem),
        );
      },
      failure: (error) {
        return ApiResult(error: 'increaseQty() addProduct is Null');
      },
    );
    return ApiResult(error: 'increaseQty() addProduct is Null');
  }

  Future<void> decreaseQty(
    String? addProductId,
    String? productId,
    num qty, {
    required String storeId,
    required String userId,
  }) async {
    log('[performRepo] decreaseQty : ');
    if (addProductId == null) {
      throw ('increaseQty() addProductId is Null');
    }
    final addProductResult = await getById(addProductId);

    addProductResult.when(
      success: (response) async {
        final addProductItem =
            response.addProductItems
                .map(
                  (e) =>
                      e.id == productId
                          ? e.copyWith(product: e.product?.copyWith(quantity: (e.product?.quantity ?? 0)))
                          : e,
                )
                .toList();

        await update(
          BaseRepoRequest(storeId: storeId, userId: userId, data: response..addProductItems = addProductItem),
        );
      },
      failure: (error) {
        return ApiResult(error: 'increaseQty() addProduct is Null');
      },
    );
  }
}
