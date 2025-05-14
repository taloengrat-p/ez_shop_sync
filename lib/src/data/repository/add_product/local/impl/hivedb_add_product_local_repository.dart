import 'dart:developer';

import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/add_product_decrease_qty_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/add_product_increase_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/add_product_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/delete_item_form_cart_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/add_product/local/i_add_product_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@Singleton(as: IAddProductLocalRepository, env: [Flavor.DEV, Flavor.PROD, Flavor.STG])
class HiveAddProductLocalRepository extends BaseHiveRepository<String, AddProduct>
    implements IAddProductLocalRepository {
  HiveAddProductLocalRepository() : super(boxName: HiveBoxConstance.addProduct);

  @override
  Future<ApiResult<List<AddProduct>>> getByUserIdWithCurrentStore(List<String> addProductsId) async {
    return getAllByIds(addProductsId);
  }

  @override
  Future<ApiResult<AddProduct>> deleteItemByIdFromCart(BaseRepoRequest<DeleteItemFormCartRequest> request) async {
    final result = await super.getById(request.data.id);

    result.when(
      success: (response) async {
        return await update(
          request.overide(
            data: response..addProductItems.removeWhere((item) => item.id == request.data.addProductItemId),
          ),
        );
      },
      failure: (error) {
        return ApiResult(error: 'Cart get By id ${request.data.id} is Null');
      },
    );

    return result;
  }

  @override
  Future<ApiResult<AddProduct>> addProductStock(BaseRepoRequest<AddProductStockRequest> request) async {
    final addProductResult = await super.getById(request.data.id);

    return addProductResult.when(
      success: (response) async {
        final productExistInCart = response.addProductItems.any(
          (item) => item.product?.id == request.data.orderItem.product?.id && item.cost == request.data.orderItem.cost,
        );

        if (productExistInCart) {
          return await update(
            request.overide(
              data:
                  response
                    ..addProductItems =
                        response.addProductItems
                            .map(
                              (OrderItem item) =>
                                  item.product?.id == request.data.orderItem.product?.id
                                      ? item.copyWith(
                                        product: item.product?.copyWith(
                                          quantity:
                                              (item.product?.quantity ?? 0) +
                                              (request.data.orderItem.product?.quantity ?? 0),
                                        ),
                                        cost: (item.cost ?? 0) + (request.data.orderItem.cost ?? 0),
                                      )
                                      : item,
                            )
                            .toList(),
            ),
          );
        } else {
          return await update(
            request.overide(
              data:
                  response
                    ..addProductItems.add(
                      OrderItem(
                        id: const Uuid().v1(),
                        product: request.data.orderItem.product,
                        cost: request.data.orderItem.cost,
                      ),
                    ),
            ),
          );
        }
      },
      failure: (error) {
        return ApiResult(error: 'Add product by ${request.data.id} is Null');
      },
    );
  }

  @override
  Future<ApiResult> increaseQty(BaseRepoRequest<AddProductIncreaseRequest> request) async {
    log('[performRepo] increaseQty : ');
    if (request.data.addProductId == null) {
      throw ('increaseQty() addProductId is Null');
    }

    final addProductResult = await super.getById(request.data.addProductId!);

    return addProductResult.when(
      success: (response) async {
        final addProductItem =
            response.addProductItems
                .map(
                  (e) =>
                      e.id == request.data.orderItemId
                          ? e.copyWith(product: e.product?.copyWith(quantity: (e.product?.quantity ?? 0)))
                          : e,
                )
                .toList();

        return await update(BaseRepoRequest.build(request, response..addProductItems = addProductItem));
      },
      failure: (error) {
        return Future.value(ApiResult(error: 'increaseQty() addProduct is Null'));
      },
    );
  }

  @override
  Future<ApiResult> decreaseQty(BaseRepoRequest<AddProductDecreaseQtyRequest> request) async {
    log('[performRepo] decreaseQty : ');
    if (request.data.addProductId == null) {
      throw ('increaseQty() addProductId is Null');
    }
    final addProductResult = await super.getById(request.data.addProductId!);

    return addProductResult.when(
      success: (response) async {
        final addProductItem =
            response.addProductItems
                .map(
                  (e) =>
                      e.id == request.data.orderItemId
                          ? e.copyWith(product: e.product?.copyWith(quantity: (e.product?.quantity ?? 0)))
                          : e,
                )
                .toList();

        await update(request.overide(data: response..addProductItems = addProductItem));
      },
      failure: (error) {
        return Future.value(ApiResult(error: 'increaseQty() addProduct is Null'));
      },
    );
  }

  @override
  Future<ApiResult<List<AddProduct>>> getAddProductByUserIdWithCurrentStore(BaseRepoRequest carts) {
    // TODO: implement getAddProductByUserIdWithCurrentStore
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<List<AddProduct>>> getAllByIds(List<String> ids) {
    // TODO: implement getAllByIds
    throw UnimplementedError();
  }
}
