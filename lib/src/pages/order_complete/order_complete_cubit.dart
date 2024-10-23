import 'package:ez_shop_sync/src/pages/order_complete/order_complete_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderCompleteCubit extends Cubit<OrderCompleteState> {
  OrderCompleteCubit() : super(OrderCompleteInitial()) {}
}
