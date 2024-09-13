import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/cart_item.dart';
import 'package:ez_shop_sync/src/data/repository/cart/cart_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/cart/cart_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/num_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartRepository cartRepository;
  BaseCubit baseCubit;
  num _serviceCharge = 0;

  List<CartItem> _products = [];
  List<CartItem> get products => _products;

  CartCubit({
    required this.cartRepository,
    required this.baseCubit,
  }) : super(CartInitial());

  num get totalPrice =>
      products.fold(0.0, (sum, item) => sum + ((item.product?.priceCurrentSelected ?? 0) * (item.product?.quantity ?? 0)));

  num get totalServiceCharge => (totalPrice * serviceChargeValue);

  num get serviceChargeValue => serviceCharge / 100;

  num get serviceCharge => _serviceCharge;

  num get totalPriceIncludeServiceCharge => totalPrice + totalServiceCharge;

  String get totalPriceDisplay => totalPriceIncludeServiceCharge.prefixCurrency();

  String get totalItems => products.fold<num>(0, (sum, item) => sum + (item.product?.quantity ?? 0)).toString();

  num get subTotalPrice => totalPrice;

  String? paymentMethod = 'qr-code';

  void increaseProductQtyByIndex(int index) {
    final item = _products[index];
    if (item.product?.quantity == null) {
      throw ('item.quantity is null');
    }

    item.product?.quantity = (_products[index].product?.quantity ?? 0) + 1;
    emit(CartIncrease(productId: item.id, qty: item.product!.quantity!));
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
  }

  void initial() {
    log('inital ${baseCubit.cart?.cartItems.map((e) => e.id).toList()}', name: runtimeType.toString());
    _products = baseCubit.cart?.cartItems.map((e) => e).toList() ?? [];
    emit(CartInitial());
  }

  void deleteItemFromCart(String id) async {
    await baseCubit.deleteItemFromCart(id);
    _products.removeWhere((e) => e.id == id);
    emit(CartRemoveItemSuccess(id));
  }

  void changePaymentMethod(String? val) {
    paymentMethod = val;
    emit(CartChangePaymentMethod(paymentMethod));
  }
}
