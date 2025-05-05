import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/order_history/order_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final int itemLength = 10;

  OrderRepository orderRepository;
  final AppCubit appCubit;

  List<ProductOrder> orderItems = [];
  QueryDocumentSnapshot? lastDocument;

  OrderHistoryCubit({required this.orderRepository, required this.appCubit}) : super(OrderHistoryInitial());

  Future<void> initialze() async {
    emit(OrderHistoryLoading());
    await loadMoreItems();
    emit(OrderHistorySuccess());
  }

  Future<void> loadMoreItems({bool refresh = false}) async {
    emit(OrderHistoryLoadMore());
    final start = orderItems.length;
    final end = orderItems.length + itemLength;

    final orderLoaded = await orderRepository.getAllRange(
      start,
      end,
      appMode: AppMode.server,
      lastDocument: refresh ? null : lastDocument,
      storeId: appCubit.store!.id,
      limit: 10,
    );

    orderLoaded.when(
      success: (response) {
        if (refresh) {
          orderItems.clear();
        }

        lastDocument = response.lastDocument;
        orderItems.addAll(response.orders);
        log('orderItems ${orderItems.length}');
        emit(OrderHistoryLoadMoreSuccess(start, end));
      },
      failure: (error) {
        emit(const OrderHistoryFailure());
      },
    );
  }
}
