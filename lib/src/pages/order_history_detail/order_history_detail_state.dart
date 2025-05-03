import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class OrderHistoryDetailState extends Equatable {
  const OrderHistoryDetailState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class OrderHistoryDetailArgruments extends OrderHistoryDetailState {
  final ProductOrder? productOrder;
  final String? orderId;
  const OrderHistoryDetailArgruments({
    this.productOrder,
    this.orderId,
  });

  @override
  String toString() => 'OrderHistoryDetailArgruments $orderId';

  @override
  List<Object?> get props => [
        productOrder,
        orderId,
      ];
}

class OrderHistoryDetailRefresh extends OrderHistoryDetailState {
  final dynamic value;

  const OrderHistoryDetailRefresh(this.value);
  @override
  String toString() => 'OrderHistoryDetailRefresh';

  @override
  List<Object?> get props => [value];
}

class OrderHistoryDetailScreenModeChange extends OrderHistoryDetailState {
  final ScreenMode mode;

  const OrderHistoryDetailScreenModeChange(this.mode);

  @override
  String toString() => 'OrderHistoryDetailScreenModeChange';
}

class OrderHistoryDetailInitial extends OrderHistoryDetailState {
  @override
  String toString() => 'OrderHistoryDetailInitial';
}

class OrderHistoryDetailInitialLoading extends OrderHistoryDetailState {
  @override
  String toString() => 'OrderHistoryDetailInitialLoading';
}

class OrderHistoryDetailLoading extends OrderHistoryDetailState {
  @override
  String toString() => 'OrderHistoryDetailLoading';
}

class OrderHistoryDetailSuccess extends OrderHistoryDetailState {
  @override
  String toString() => 'OrderHistoryDetailSuccess';
}

class OrderHistoryDetailFailure extends OrderHistoryDetailState {
  const OrderHistoryDetailFailure();

  @override
  String toString() => 'OrderHistoryDetailFailure';
}
