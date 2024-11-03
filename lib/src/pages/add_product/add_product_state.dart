import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:injectable/injectable.dart';

abstract class AddProductState extends Equatable {
  const AddProductState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class AddProductRefresh extends AddProductState {
  final dynamic value;

  const AddProductRefresh(this.value);
  @override
  String toString() => 'AddProductRefresh';

  @override
  List<Object?> get props => [value];
}

class AddProductScreenModeChange extends AddProductState {
  final ScreenMode mode;

  const AddProductScreenModeChange(this.mode);

  @override
  String toString() => 'AddProductScreenModeChange';
}

class AddProductInitial extends AddProductState {
  @override
  String toString() => 'AddProductInitial';
}

class AddProductLoading extends AddProductState {
  @override
  String toString() => 'AddProductLoading';
}

class AddProductProductInsufficient extends AddProductState {
  @override
  String toString() => 'AddProductProductInsufficient';
}

class AddProductSuccess extends AddProductState {
  final AddProduct? addProduct;

  const AddProductSuccess(this.addProduct);

  @override
  String toString() => 'AddProductSuccess $addProduct';

  @override
  List<Object?> get props => [addProduct];
}

class AddProductFailure extends AddProductState {
  const AddProductFailure();

  @override
  String toString() => 'AddProductFailure';
}

class AddProductUpdateTotalPrice extends AddProductState {
  final num? totalPrice;

  const AddProductUpdateTotalPrice(this.totalPrice);

  @override
  String toString() => 'AddProductUpdateTotalPrice $totalPrice';

  @override
  List<Object?> get props => [totalPrice];
}

class AddProductChangePaymentMethod extends AddProductState {
  final String? value;
  const AddProductChangePaymentMethod(this.value);

  @override
  String toString() => 'AddProductChangePaymentMethod $value';

  @override
  List<Object?> get props => [value];
}

class AddProductIncrease extends AddProductState {
  final String productId;
  final num qty;

  const AddProductIncrease({
    required this.productId,
    required this.qty,
  });

  @override
  String toString() => 'AddProductIncrease $productId, qty: $qty';

  @override
  List<Object?> get props => [productId, qty];
}

class AddProductDecrease extends AddProductState {
  final String productId;
  final num qty;

  const AddProductDecrease({
    required this.productId,
    required this.qty,
  });

  @override
  String toString() => 'AddProductDecrease $productId, qty: $qty';

  @override
  List<Object?> get props => [productId, qty];
}

class AddProductRemoveItemSuccess extends AddProductState {
  final String id;

  const AddProductRemoveItemSuccess(this.id);

  @override
  String toString() => 'AddProductScreenModeChange id: $id';

  @override
  List<Object?> get props => [id];
}
