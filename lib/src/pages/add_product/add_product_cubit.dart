import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/add_product_decrease_qty_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/add_product_increase_request.dart';
import 'package:ez_shop_sync/src/data/repository/add_product/add_product_repository.dart';
import 'package:ez_shop_sync/src/data/repository/add_product_history/add_product_history_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/add_product/add_product_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/num_extension.dart';
import 'package:ez_shop_sync/src/utils/timer_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AddProductCubit extends Cubit<AddProductState> {
  final ProductRepository productRepository;
  final AddProductHistoryRepository addProductHistoryRepository;
  final AddProductRepository addProductRepository;
  final AppCubit appCubit;

  AddProduct? _addProduct;

  List<OrderItem> get addProductOrderItems => _addProduct?.addProductItems ?? [];
  TimerUtils timerUtils = TimerUtils();
  List<Product> productInStock = [];

  bool get hasAnyError => addProductOrderItems.any((item) {
    if (productInStock.isEmpty) {
      return true;
    }

    try {
      productInStock
          .firstWhere((e) => e.id == item.product?.id)
          .productTypeList
          ?.firstWhere((e) => e.id == item.product?.priceSelected);
      // final stockQty = (productStockItem?.quantity ?? 0);
      // final addStockQty = (item.product?.quantity ?? 0);

      return false;
    } catch (e) {
      return true;
    }
  });

  AddProductCubit({
    required this.productRepository,
    required this.addProductHistoryRepository,
    required this.appCubit,
    required this.addProductRepository,
  }) : super(AddProductInitial());

  num? get totalPrice => _addProduct?.addProductItems.fold(0.0, (sum, item) => (sum ?? 0) + ((item.cost ?? 0)));

  String get totalPriceDisplay => totalPrice?.prefixCurrency() ?? '--';

  String get totalItems =>
      _addProduct?.addProductItems.fold<num>(0, (sum, item) => sum + (item.product?.quantity ?? 0)).toString() ?? '--';

  bool get disabledSubmit => totalPrice == null;

  void increaseProductQtyByIndex(int index) {
    final item = _addProduct?.addProductItems.elementAtOrNull(index);
    if (item?.product?.quantity == null) {
      throw ('item.quantity is null');
    }

    item?.product?.quantity = (_addProduct?.addProductItems.elementAtOrNull(index)?.product?.quantity ?? 0) + 1;
    emit(AddProductIncrease(productId: item?.id, qty: (item?.product?.quantity ?? 0)));

    timerUtils.debounceTime(const Duration(milliseconds: 500), () {
      addProductRepository.increaseQty(
        appCubit.request(
          AddProductIncreaseRequest(
            addProductId: _addProduct?.id,
            orderItemId: item?.product?.id,
            qty: item?.product?.quantity ?? 0,
          ),
        ),
      );
    });
  }

  void decreaseProductQtyByIndex(int index) {
    final item = _addProduct?.addProductItems.elementAtOrNull(index);
    if (item?.product?.quantity == null) {
      throw ('item.quantity is null');
    }

    if (item?.product?.quantity == 1) {
      return;
    }

    item?.product?.quantity = (_addProduct?.addProductItems.elementAtOrNull(index)?.product?.quantity ?? 1) - 1;

    emit(AddProductDecrease(productId: item?.id, qty: (item?.product?.quantity ?? 0)));

    timerUtils.debounceTime(const Duration(milliseconds: 500), () {
      addProductRepository.decreaseQty(
        appCubit.request(
          AddProductDecreaseQtyRequest(
            addProductId: _addProduct?.id,
            orderItemId: item?.id,
            qty: item?.product?.quantity ?? 0,
          ),
        ),
      );
    });
  }

  void initial() async {
    emit(AddProductInitial());

    _addProduct = appCubit.addProduct;

    productInStock = await getProductsByCartItems();
    emit(AddProductInitialSuccess());
  }

  void deleteItemFromCart(String id) async {
    final result = await appCubit.deleteItemFromAddProduct(id);

    result.when(
      success: (response) {
        _addProduct?.addProductItems.removeWhere((e) => e.id == id);
        emit(AddProductRemoveItemSuccess(id));
      },
      failure: (error) {
        emit(AddProductRemoveItemFailure(id));
      },
    );
  }

  void submit() async {
    if (_addProduct == null) {
      throw Exception('submit _addProduct == null');
    }

    emit(AddProductLoading());

    final result = await getProductsByCartItems();

    productInStock = result;

    if (hasAnyError) {
      emit(AddProductProductInsufficient());
      return;
    }

    final addProductCompleted = await addProductHistoryRepository.create(
      appCubit.request(_addProduct!.copyWith(amountCost: totalPrice)),
    );

    addProductCompleted.when(
      success: (response) async {
        if (_addProduct != null) {
          // await productRepository.orderCompletedUpdate(_cart);
          await addProductRepository.update(appCubit.request(_addProduct!..addProductItems = []));
        }
        emit(AddProductSuccess(addProductCompleted.response));
      },
      failure: (error) {
        emit(const AddProductFailure());
      },
    );
  }

  Future<List<Product>> getProductsByCartItems() async {
    final productStockFromCartItem = await productRepository.getByIds(
      appCubit.store!.id,
      _addProduct?.addProductItems.map((e) => e.product?.id.toString() ?? '').toList() ?? [],
    );

    return productStockFromCartItem.response ?? [];
  }

  void setTotalPrice(String? value) {
    // totalPrice = num.tryParse(value ?? '0') ?? 0;
    // _addProduct?.amountCost = totalPrice ?? 0;
    // emit(AddProductUpdateTotalPrice(totalPrice));
  }
}
