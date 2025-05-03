import 'dart:developer';

import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_add_stock_request.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@Singleton()
@Injectable()
class AddProductLocalRepository extends BaseHiveRepository<String, AddProduct> {
  AddProductLocalRepository() : super(boxName: HiveBoxConstance.addProduct);

  List<AddProduct> getByUserIdWithCurrentStore(List<String> addProductsId) {
    return getAllById(addProductsId);
  }

  Future<AddProduct> createIfNotExist(CreateAddProductRequest request) async {
    AddProduct? result = getById(request.addProduct.id);
    if (result == null) {
      return await create(request.addProduct, userId: request.userId);
    } else {
      return result;
    }
  }

  Future<AddProduct> deleteItemByIdFromCart(String? id, String addProductItemId) async {
    if (id == null) {
      throw ('id is Null');
    }

    AddProduct? result = getById(id);

    if (result == null) {
      throw ('Cart get By id $id is Null');
    }

    return await update(id, result..addProductItems.removeWhere((item) => item.id == addProductItemId));
  }

  Future<AddProduct?> addProduct(String id, Product product) async {
    AddProduct? addProduct = getById(id);

    if (addProduct == null) {
      throw ('Cart by $id is Null');
    }

    final productExistInCart = addProduct.addProductItems.any(
      (item) => item.product?.id == product.id && item.product?.priceSelected == product.priceSelected,
    );

    if (productExistInCart) {
      return await update(
        id,
        addProduct
          ..addProductItems =
              addProduct.addProductItems
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
      );
    } else {
      return await update(id, addProduct..addProductItems.add(OrderItem(id: const Uuid().v1(), product: product)));
    }
  }

  Future<void> increaseQty(String? addProductId, String? productId, num qty) async {
    log('[performRepo] increaseQty : ');
    if (addProductId == null) {
      throw ('increaseQty() addProductId is Null');
    }
    final AddProduct? addProduct = getById(addProductId);
    if (addProduct == null) {
      throw ('increaseQty() addProduct is Null');
    }

    final addProductItem =
        addProduct.addProductItems
            .map(
              (e) =>
                  e.id == productId
                      ? e.copyWith(product: e.product?.copyWith(quantity: (e.product?.quantity ?? 0)))
                      : e,
            )
            .toList();

    await update(addProductId, addProduct..addProductItems = addProductItem);
  }

  Future<void> decreaseQty(String? addProductId, String? productId, num qty) async {
    log('[performRepo] decreaseQty : ');
    if (addProductId == null) {
      throw ('increaseQty() addProductId is Null');
    }
    final AddProduct? addProduct = getById(addProductId);
    if (addProduct == null) {
      throw ('increaseQty() addProduct is Null');
    }

    final addProductItem =
        addProduct.addProductItems
            .map(
              (e) =>
                  e.id == productId
                      ? e.copyWith(product: e.product?.copyWith(quantity: (e.product?.quantity ?? 0)))
                      : e,
            )
            .toList();

    await update(addProductId, addProduct..addProductItems = addProductItem);
  }
}
