import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/order_history_detail/order_history_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderHistoryDetailCubit extends Cubit<OrderHistoryDetailState> {
  final OrderRepository orderRepository;
  OrderHistoryDetailArgruments? _argruments;
  final AppCubit baseCubit;
  ProductOrder? orderHistory;
  OrderHistoryDetailCubit({
    required this.orderRepository,
    required this.baseCubit,
  }) : super(OrderHistoryDetailInitial());

  ProductOrder? get order => orderHistory;

  void initialize(OrderHistoryDetailArgruments argruments) async {
    _argruments = argruments;
    orderHistory = _argruments?.productOrder;

    if (_argruments?.productOrder == null && _argruments?.orderId != null) {
      emit(OrderHistoryDetailInitialLoading());
      final result = await orderRepository.getOrderHistoryDetail(
          baseCubit.store!.id, _argruments!.orderId!);

      result.when(
        success: (response) {
          orderHistory = response;

          emit(OrderHistoryDetailInitial());
        },
        failure: (error) {
          emit(const OrderHistoryDetailFailure());
        },
      );
    }
  }
}
