import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:ez_shop_sync/src/pages/order_history/order_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final int itemLength = 10;

  OrderRepository orderRepository;

  List<ProductOrder> orderItems = [];

  OrderHistoryCubit({
    required this.orderRepository,
  }) : super(OrderHistoryInitial());

  initialze() {
    emit(OrderHistoryLoading());
    loadMoreItems();
    emit(OrderHistorySuccess());
  }

  Future<void> loadMoreItems() async {
    emit(OrderHistoryLoadMore());
    final start = orderItems.length;
    final end = orderItems.length + itemLength;
    final orderLoaded = orderRepository.getAllRange(start, end);
    orderItems.addAll(orderLoaded);
    emit(OrderHistoryLoadMoreSuccess(start, end));
  }
}
