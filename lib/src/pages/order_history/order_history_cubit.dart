import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/dto/request/pagination_index_request.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/order_history/order_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit({required this.orderRepository, required this.appCubit}) : super(OrderHistoryInitial());

  final int itemLength = 10;

  final OrderRepository orderRepository;
  final AppCubit appCubit;

  List<ProductOrder> orderItems = [];
  QueryDocumentSnapshot? lastDocument;

  Future<void> initialze() async {
    emit(OrderHistoryInitialLoading());
    await loadMoreItems(disabledState: true);
    emit(OrderHistorySuccess());
  }

  Future<void> loadMoreItems({bool refresh = false, bool disabledState = false}) async {
    if (!disabledState) {
      emit(OrderHistoryLoadMore());
    }
    final start = orderItems.length;
    final end = orderItems.length + itemLength;

    final orderLoaded = await orderRepository.getAllRange(
      appCubit.request(
        PaginationIndexRequest(start: start, end: end, lastDocument: refresh ? null : lastDocument, limit: 10),
      ),
    );

    orderLoaded.when(
      success: (response) {
        if (refresh) {
          orderItems.clear();
        }

        lastDocument = response.lastDocument;
        orderItems.addAll(response.orders);
        log('orderItems ::: ${orderItems.length}');
        if (!disabledState) {
          emit(OrderHistoryLoadMoreSuccess(start, end));
        }
      },
      failure: (error) {
        emit(const OrderHistoryFailure());
      },
    );
  }
}
