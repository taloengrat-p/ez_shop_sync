// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/payment_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class CartState extends Equatable {
  const CartState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class CartRefresh extends CartState {
  final dynamic value;

  const CartRefresh(this.value);
  @override
  String toString() => 'CartRefresh';

  @override
  List<Object?> get props => [value];
}

class CartScreenModeChange extends CartState {
  final ScreenMode mode;

  const CartScreenModeChange(this.mode);

  @override
  String toString() => 'CartScreenModeChange';
}

class CartInitial extends CartState {
  @override
  String toString() => 'CartInitial';
}

class CartGetProductsSuccess extends CartState {
  @override
  String toString() => 'CartGetProductsSuccess';
}

class CartGetProductsFailure extends CartState {
  @override
  String toString() => 'CartGetProductsFailure';
}

class CartLoading extends CartState {
  @override
  String toString() => 'CartLoading';
}

class CartAddProductFromSearchSuccess extends CartState {
  @override
  String toString() => 'CartAddProductFromSearchSuccess';
}

class CartSearchProductLoading extends CartState {
  // final String key;
  const CartSearchProductLoading();
  @override
  String toString() => 'CartSearchProductLoading ';

  // @override
  // List<Object?> get props => [key];
}

class CartSearchProductFailure extends CartState {
  @override
  String toString() => 'CartSearchProductFailure';
}

class CartSearchProductSuccess extends CartState {
  const CartSearchProductSuccess();

  @override
  String toString() => 'CartSearchProductSuccess';
}

class CartProductInsufficient extends CartState {
  @override
  String toString() => 'CartProductInsufficient';
}

class CartSuccess extends CartState {
  final ProductOrder? ordered;
  const CartSuccess(this.ordered);

  @override
  String toString() => 'CartSuccess $order';

  @override
  List<Object?> get props => [ordered];
}

class CartFailure extends CartState {
  final ApiError apiError;
  const CartFailure(this.apiError);

  @override
  String toString() => 'CartFailure $apiError';
  @override
  List<Object?> get props => [apiError];
}

class CartChangePaymentMethod extends CartState {
  final PaymentMethodType? value;
  const CartChangePaymentMethod(this.value);

  @override
  String toString() => 'CartChangePaymentMethod $value';

  @override
  List<Object?> get props => [value];
}

class CartIncrease extends CartState {
  final String productId;
  final num qty;

  const CartIncrease({required this.productId, required this.qty});

  @override
  String toString() => 'CartIncrease $productId, qty: $qty';

  @override
  List<Object?> get props => [productId, qty];
}

class CartDecrease extends CartState {
  final String productId;
  final num qty;

  const CartDecrease({required this.productId, required this.qty});

  @override
  String toString() => 'CartDecrease $productId, qty: $qty';

  @override
  List<Object?> get props => [productId, qty];
}

class CartRemoveItemSuccess extends CartState {
  final String id;

  const CartRemoveItemSuccess(this.id);

  @override
  String toString() => 'CartRemoveItemSuccess id: $id';

  @override
  List<Object?> get props => [id];
}

class CartRemoveItemFailure extends CartState {
  final String id;

  const CartRemoveItemFailure(this.id);

  @override
  String toString() => 'CartRemoveItemFailure id: $id';

  @override
  List<Object?> get props => [id];
}
