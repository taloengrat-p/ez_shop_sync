import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/order_history_detail/order_history_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class OrderHistoryDetailCubit extends Cubit<OrderHistoryDetailState> {
  final OrderRepository orderRepository;
  final AppCubit appCubit;
  OrderHistoryDetailArgruments? _argruments;
  ProductOrder? orderHistory;
  OrderHistoryDetailCubit({required this.orderRepository, required this.appCubit}) : super(OrderHistoryDetailInitial());

  ProductOrder? get order => orderHistory;

  void initialize(OrderHistoryDetailArgruments argruments) async {
    _argruments = argruments;
    orderHistory = _argruments?.productOrder;

    if (_argruments?.productOrder == null && _argruments?.orderId != null) {
      emit(OrderHistoryDetailInitialLoading());
      final result = await orderRepository.getOrderHistoryDetail(appCubit.store!.id, _argruments!.orderId!);

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
