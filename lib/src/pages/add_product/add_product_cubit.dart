import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_add_stock_request.dart';
import 'package:ez_shop_sync/src/data/repository/add_product/add_product_repository.dart';
import 'package:ez_shop_sync/src/data/repository/add_product_history/add_product_history_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/pages/add_product/add_product_state.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/utils/extensions/num_extension.dart';
import 'package:ez_shop_sync/src/utils/timer_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductCubit extends Cubit<AddProductState> {
  final ProductRepository productRepository;
  final AddProductHistoryRepository addProductHistoryRepository;
  final AddProductRepository addProductRepository;
  final BaseCubit baseCubit;
  List<OrderItem> _products = [];
  AddProduct? _addProduct;
  List<OrderItem> get products => _products;
  TimerUtils timerUtils = TimerUtils();
  Map<String, Product> productInStock = {};
  AddProductCubit({
    required this.productRepository,
    required this.addProductHistoryRepository,
    required this.baseCubit,
    required this.addProductRepository,
  }) : super(AddProductInitial());

  num? totalPrice;
  String get totalPriceDisplay => totalPrice?.prefixCurrency() ?? '--';

  String get totalItems => products.fold<num>(0, (sum, item) => sum + (item.product?.quantity ?? 0)).toString();

  bool get disabledSubmit => totalPrice == null;

  void increaseProductQtyByIndex(int index) {
    final item = _products[index];
    if (item.product?.quantity == null) {
      throw ('item.quantity is null');
    }

    item.product?.quantity = (_products[index].product?.quantity ?? 0) + 1;
    emit(AddProductIncrease(productId: item.id, qty: item.product!.quantity!));

    timerUtils.debounceTime(
      const Duration(milliseconds: 500),
      () {
        addProductRepository.decreaseQty(baseCubit.cart?.id, item.product?.id, item.product?.quantity ?? 0);
      },
    );
  }

  void decreaseProductQtyByIndex(int index) {
    final item = _products[index];
    if (item.product?.quantity == null) {
      throw ('item.quantity is null');
    }

    if (item.product?.quantity == 1) {
      return;
    }

    item.product?.quantity = _products[index].product!.quantity! - 1;
    emit(AddProductDecrease(productId: item.id, qty: item.product!.quantity!));

    timerUtils.debounceTime(
      const Duration(milliseconds: 500),
      () {
        addProductRepository.decreaseQty(baseCubit.cart?.id, item.product?.id, item.product?.quantity ?? 0);
      },
    );
  }

  void initial() {
    _addProduct = baseCubit.addProduct;
    _products = baseCubit.addProduct?.addProductItems.map((e) => e).toList() ?? [];
    productInStock = getProductsByCartItems();
    emit(AddProductInitial());
  }

  void deleteItemFromCart(String id) async {
    await baseCubit.deleteItemFromCart(id);
    _products.removeWhere((e) => e.id == id);
    emit(AddProductRemoveItemSuccess(id));
  }

  void submit() async {
    if (_addProduct == null) {
      throw Exception('submit _addProduct == null');
    }

    emit(AddProductLoading());

    final addProductCompleted = await addProductHistoryRepository.create(
      CreateAddProductRequest(
        storeId: baseCubit.store!.id,
        userId: baseCubit.user!.id,
        addProduct: _addProduct!.copyWith(),
      ),
    );

    emit(AddProductSuccess(addProductCompleted));
  }

  Map<String, Product> getProductsByCartItems() {
    final productStockFromCartItem =
        productRepository.getByIds(_products.map((e) => e.product?.id.toString() ?? '').toList()).toList();

    return {
      for (var item in productStockFromCartItem) item.id: item,
    };
  }

  void setTotalPrice(String? value) {
    totalPrice = num.tryParse(value ?? '0') ?? 0;
    _addProduct?.amountCost = totalPrice ?? 0;
    emit(AddProductUpdateTotalPrice(totalPrice));
  }
}
