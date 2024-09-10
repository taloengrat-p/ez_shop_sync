import 'package:equatable/equatable.dart';
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

class CartLoading extends CartState {
  @override
  String toString() => 'CartLoading';
}

class CartSuccess extends CartState {
  @override
  String toString() => 'CartSuccess';
}

class CartFailure extends CartState {
  const CartFailure();

  @override
  String toString() => 'CartFailure';
}

class CartChangePaymentMethod extends CartState {
  final String? value;
  const CartChangePaymentMethod(this.value);

  @override
  String toString() => 'CartChangePaymentMethod $value';

  @override
  List<Object?> get props => [value];
}

class CartIncrease extends CartState {
  final String productId;
  final num qty;

  const CartIncrease({
    required this.productId,
    required this.qty,
  });

  @override
  String toString() => 'CartIncrease $productId, qty: $qty';

  @override
  List<Object?> get props => [productId, qty];
}

class CartDecrease extends CartState {
  final String productId;
  final num qty;

  const CartDecrease({
    required this.productId,
    required this.qty,
  });

  @override
  String toString() => 'CartDecrease $productId, qty: $qty';

  @override
  List<Object?> get props => [productId, qty];
}

class CartRemoveItemSuccess extends CartState {
  final String id;

  const CartRemoveItemSuccess(this.id);

  @override
  String toString() => 'CartScreenModeChange id: $id';

  @override
  List<Object?> get props => [id];
}
