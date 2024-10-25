import 'package:ez_shop_sync/src/pages/cart/cart_state.dart';
import 'package:ez_shop_sync/src/pages/order_complete/order_complete_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderCompleteCubit extends Cubit<OrderCompleteState> {
  CartSuccess? argruments;

  OrderCompleteCubit() : super(OrderCompleteInitial());

  void setArgruments(CartSuccess? argruments) {
    this.argruments = argruments;
    emit(OrderCompleteInitial());
  }
}
