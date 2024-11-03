import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_method_type.enum.dart';
import 'package:ez_shop_sync/src/pages/order_complete/order_complete_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderCompleteCubit extends Cubit<OrderCompleteState> {
  OrderCompleteArgrument? argruments;

  OrderCompleteCubit() : super(OrderCompleteInitial());

  DateTime? get createDate => argruments?.transactionMethodType == TransactionMethodType.order
      ? argruments?.orderItems?.createDate
      : argruments?.transactionMethodType == TransactionMethodType.addProduct
          ? argruments?.addProductItems?.createDate
          : null;

  String get transactionId => switch (argruments?.transactionMethodType) {
        TransactionMethodType.order => argruments?.orderItems?.id,
        TransactionMethodType.addProduct => argruments?.addProductItems?.id,
        TransactionMethodType.undefined => 'undefined',
        null => '',
      };

  void setArgruments(OrderCompleteArgrument? argruments) {
    this.argruments = argruments;
    emit(OrderCompleteInitial());
  }
}
