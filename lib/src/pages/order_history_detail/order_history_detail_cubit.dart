import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/pages/order_history_detail/order_history_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderHistoryDetailCubit extends Cubit<OrderHistoryDetailState> {
  OrderHistoryDetailArgruments? argruments;
  OrderHistoryDetailCubit() : super(OrderHistoryDetailInitial());

  ProductOrder? get order => argruments?.productOrder;

  void initialize(OrderHistoryDetailArgruments argruments) {
    this.argruments = argruments;
    emit(OrderHistoryDetailInitial());
  }
}
