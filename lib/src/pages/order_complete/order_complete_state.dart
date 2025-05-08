import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_method_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class OrderCompleteState extends Equatable {
  const OrderCompleteState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class OrderCompleteArgrument extends OrderCompleteState {
  final String title;
  final ProductOrder? orderItem;
  final AddProduct? addProductItems;
  final TransactionMethodType? transactionMethodType;
  final String from;

  const OrderCompleteArgrument({
    required this.title,
    this.orderItem,
    this.transactionMethodType,
    this.addProductItems,
    required this.from,
  });
  @override
  String toString() =>
      'OrderCompleteRefresh $title $orderItem $transactionMethodType';

  @override
  List<Object?> get props => [
        title,
        orderItem,
        transactionMethodType,
        from,
      ];
}

class OrderCompleteRefresh extends OrderCompleteState {
  final dynamic value;

  const OrderCompleteRefresh(this.value);
  @override
  String toString() => 'OrderCompleteRefresh';

  @override
  List<Object?> get props => [value];
}

class OrderCompleteScreenModeChange extends OrderCompleteState {
  final ScreenMode mode;

  const OrderCompleteScreenModeChange(this.mode);

  @override
  String toString() => 'OrderCompleteScreenModeChange';
}

class OrderCompleteInitial extends OrderCompleteState {
  @override
  String toString() => 'OrderCompleteInitial';
}

class OrderCompleteLoading extends OrderCompleteState {
  @override
  String toString() => 'OrderCompleteLoading';
}

class OrderCompleteSuccess extends OrderCompleteState {
  @override
  String toString() => 'OrderCompleteSuccess';
}

class OrderCompleteFailure extends OrderCompleteState {
  const OrderCompleteFailure();

  @override
  String toString() => 'OrderCompleteFailure';
}
