import 'dart:developer';

import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/order_status_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/payment_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/cart_request/cart_decrease_qty_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/cart_request/cart_increase_qty_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_order_request.dart';
import 'package:ez_shop_sync/src/data/repository/cart/cart_repository.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/cart/cart_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/num_extension.dart';
import 'package:ez_shop_sync/src/utils/timer_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class CartCubit extends Cubit<CartState> {
  final CartRepository cartRepository;
  final OrderRepository orderRepository;
  final ProductRepository productRepository;
  final AppCubit appCubit;

  final num _serviceCharge = 7;
  TimerUtils timerUtils = TimerUtils();
  List<OrderItem> _products = [];
  Cart? _cart;
  List<OrderItem> get products => _products;
  CartCubit({
    required this.cartRepository,
    required this.appCubit,
    required this.orderRepository,
    required this.productRepository,
  }) : super(CartInitial());

  num get totalPrice => products.fold(0.0, (sum, item) => sum + ((item.product?.priceCurrentSelected ?? 0)));

  num get totalServiceCharge => (totalPrice * serviceChargeValue);

  num get serviceChargeValue => serviceCharge / 100;

  num get serviceCharge => _serviceCharge;

  num get totalPriceIncludeServiceCharge => totalPrice + totalServiceCharge;

  String get totalPriceDisplay => totalPriceIncludeServiceCharge.prefixCurrency();

  String get totalItems => products.fold<num>(0, (sum, item) => sum + (item.product?.quantity ?? 0)).toString();
  num? receiveAmount;
  num get subTotalPrice => totalPrice;
  bool get hasAnyError => products.any((item) {
    // log('_cubit.products.length ${_cubit.products.length}, $index, ${product.quantity}');

    if (productInStock.isEmpty) {
      return true;
    }

    try {
      final productStockItem = productInStock
          .firstWhere((e) => e.id == item.product?.id)
          .productTypeList
          ?.firstWhere((e) => e.id == item.product?.priceSelected);

      final hasError = (productStockItem?.quantity ?? 0) < (item.product?.quantity ?? 0);
      return hasError;
    } catch (e) {
      return true;
    }
  });
  PaymentMethodType? paymentMethod = PaymentMethodType.undefined;

  List<Product> productInStock = [];

  num? get changeAmountDisplay => (receiveAmount ?? 0) - totalPrice;

  void increaseProductQtyByIndex(int index) {
    final item = _products[index];
    if (item.product?.quantity == null) {
      throw ('item.quantity is null');
    }

    item.product?.quantity = (_products[index].product?.quantity ?? 0) + 1;
    emit(CartIncrease(productId: item.id, qty: item.product!.quantity!));

    timerUtils.debounceTime(const Duration(milliseconds: 500), () {
      log('[perform] increase');
      cartRepository.increaseQty(
        BaseRepoRequest(
          storeId: appCubit.storeId ?? '',
          userId: appCubit.userId,
          data: CartIncreaseQtyRequest(
            cartId: appCubit.cart?.id,
            productId: item.product?.id,
            qty: item.product?.quantity ?? 0,
          ),
        ),
      );
    });
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
    emit(CartDecrease(productId: item.id, qty: item.product!.quantity!));

    timerUtils.debounceTime(const Duration(milliseconds: 500), () {
      log('[perform] decrease');
      cartRepository.decreaseQty(
        BaseRepoRequest(
          storeId: appCubit.storeId,
          userId: appCubit.userId,
          data: CartDecreaseQtyRequest(
            cartId: appCubit.cart?.id,
            productId: item.product?.id,
            qty: item.product?.quantity ?? 0,
          ),
        ),
      );
    });
  }

  void initial() async {
    emit(CartInitial());
    _cart = appCubit.cart;
    _products = appCubit.cart?.cartItems.map((e) => e).toList() ?? [];
    paymentMethod = PaymentMethodType.cash;
    final result = await getProductsByCartItems();

    result.when(
      success: (response) {
        productInStock = response;
        emit(CartGetProductsSuccess());
      },
      failure: (error) {
        emit(CartGetProductsFailure());
      },
    );
  }

  void deleteItemFromCart(String? id) async {
    throwIf(id == null, 'deleteItemFromCart id == null');

    final result = await appCubit.deleteItemFromCart(id!);

    result.when(
      success: (response) {
        _products.removeWhere((e) => e.id == id);
        emit(CartRemoveItemSuccess(id));
      },
      failure: (error) {
        emit(CartRemoveItemFailure(id));
      },
    );
  }

  void changePaymentMethod(PaymentMethodType? val) {
    paymentMethod = val;
    emit(CartChangePaymentMethod(paymentMethod));
  }

  void submit() async {
    if (_cart == null) {
      throw Exception('submit _cart == null');
    }

    emit(CartLoading());

    final result = await getProductsByCartItems();

    productInStock = result.response ?? [];

    if (hasAnyError) {
      emit(CartProductInsufficient());
      return;
    }

    throwIf(_cart == null, 'can not create order : cart is null');

    final orderCreated = await orderRepository.createFromCart(
      BaseRepoRequest(
        storeId: appCubit.store?.id ?? '',
        userId: appCubit.user?.uid ?? '',
        data: CreateOrderRequest(
          cart: _cart!,
          orderItems: _cart?.cartItems ?? [],
          status: paymentMethod == PaymentMethodType.cash ? OrderStatusType.complete : OrderStatusType.waitPayment,
          paymentType: paymentMethod ?? PaymentMethodType.undefined,
          receiveAmount: receiveAmount,
          changeAmount: changeAmountDisplay,
          serviceCharge: serviceCharge,
        ),
      ),
    );

    await orderCreated.when(
      success: (response) async {
        if (_cart != null) {
          // await productRepository.orderCompletedUpdate(_cart);
          await cartRepository.update(
            BaseRepoRequest(
              storeId: appCubit.store?.id ?? '',
              userId: appCubit.user?.uid ?? '',
              data: _cart!..cartItems = [],
            ),
          );
        }

        emit(CartSuccess(response));
      },
      failure: (error) {
        emit(CartFailure(error));
      },
    );
  }

  Future<ApiResult<List<Product>>> getProductsByCartItems() async {
    final result = await productRepository.getByIds(
      appCubit.store?.id,
      _products.map((e) => e.product?.id.toString() ?? '').toList(),
    );

    return result;
  }

  void setReceiveAmount(String? value) {
    receiveAmount = num.tryParse(value.toString());
    emit(CartRefresh(DateTime.now()));
  }
}
