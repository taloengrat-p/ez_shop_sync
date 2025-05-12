// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@Singleton(env: [Flavor.DEV])
@Injectable(env: [Flavor.DEV])
class AddProductHistoryLocalRepository extends BaseHiveRepository<String, AddProduct> {
  AddProductHistoryLocalRepository() : super(boxName: HiveBoxConstance.addProductHistory);

  Future<ApiResult<List<AddProduct>>> getByUserIdWithCurrentStore(List<String> addProductsId) async {
    return getAllByIds(addProductsId);
  }

  Future<ApiResult<AddProduct>> deleteItemByIdFromCart(BaseRepoRequest<AddProductDeleteItemRequest> request) async {
    if (request.data.id == null) {
      throw ('id is Null');
    }

    final result = await getById(request.data.id!);

    result.when(
      success: (response) async {
        return await update(
          request.overide(
            data: response..addProductItems.removeWhere((item) => item.id == request.data.addProductItemId),
          ),
        );
      },
      failure: (error) {
        return Future.value(ApiResult(error: 'Cart get By id ${request.data.id} is Null'));
      },
    );

    return Future.value(ApiResult(error: 'Cart get By id ${request.data.id} is Null'));
  }

  Future<ApiResult<AddProduct>> addProduct(BaseRepoRequest<AddProductRequest> request) async {
    final addProductResult = await getById(request.data.id);

    addProductResult.when(
      success: (response) async {
        final productExistInCart = response.addProductItems.any(
          (item) =>
              item.product?.id == request.data.product.id &&
              item.product?.priceSelected == request.data.product.priceSelected,
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
            request.overide(
              data: response..addProductItems.add(OrderItem(id: const Uuid().v1(), product: request.data.product)),
            ),
          );
        }
      },
      failure: (error) {
        return ApiResult(error: 'Cart by ${request.data.id} is Null');
      },
    );
    return ApiResult(error: 'Cart by ${request.data.id} is Null');
  }

  // Future<ApiResult> increaseQty(String? addProductId, String? productId, num qty) async {
  //   log('[performRepo] increaseQty : ');
  //   if (addProductId == null) {
  //     throw ('increaseQty() addProductId is Null');
  //   }
  //   final addProductResult = await getById(addProductId);

  //   addProductResult.when(
  //     success: (response) async {
  //       final addProductItem =
  //           response.addProductItems
  //               .map(
  //                 (e) =>
  //                     e.id == productId
  //                         ? e.copyWith(product: e.product?.copyWith(quantity: (e.product?.quantity ?? 0)))
  //                         : e,
  //               )
  //               .toList();

  //       await update(
  //         BaseRepoRequest(storeId: storeId, userId: userId, data: response..addProductItems = addProductItem),
  //       );
  //     },
  //     failure: (error) {
  //       return ApiResult(error: 'increaseQty() addProduct is Null');
  //     },
  //   );
  //   return ApiResult(error: 'increaseQty() addProduct is Null');
  // }

  // Future<void> decreaseQty(
  //   String? addProductId,
  //   String? productId,
  //   num qty, {
  //   required String storeId,
  //   required String userId,
  // }) async {
  //   log('[performRepo] decreaseQty : ');
  //   if (addProductId == null) {
  //     throw ('increaseQty() addProductId is Null');
  //   }
  //   final addProductResult = await getById(addProductId);

  //   addProductResult.when(
  //     success: (response) async {
  //       final addProductItem =
  //           response.addProductItems
  //               .map(
  //                 (e) =>
  //                     e.id == productId
  //                         ? e.copyWith(product: e.product?.copyWith(quantity: (e.product?.quantity ?? 0)))
  //                         : e,
  //               )
  //               .toList();

  //       await update(
  //         BaseRepoRequest(storeId: storeId, userId: userId, data: response..addProductItems = addProductItem),
  //       );
  //     },
  //     failure: (error) {
  //       return ApiResult(error: 'increaseQty() addProduct is Null');
  //     },
  //   );
  // }
}

class AddProductRequest {
  final String id;
  final Product product;
  AddProductRequest({required this.id, required this.product});
}

class AddProductDeleteItemRequest {
  final String? id;
  final String addProductItemId;
  AddProductDeleteItemRequest({this.id, required this.addProductItemId});
}
