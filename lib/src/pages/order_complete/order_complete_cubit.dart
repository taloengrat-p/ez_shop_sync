import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_method_type.enum.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/order_complete/order_complete_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class OrderCompleteCubit extends Cubit<OrderCompleteState> {
  final AppCubit appCubit;

  OrderCompleteArgrument? argruments;

  OrderCompleteCubit({required this.appCubit}) : super(OrderCompleteInitial());

  DateTime? get createDate =>
      argruments?.transactionMethodType == TransactionMethodType.order
          ? argruments?.orderItem?.info?.createAtDateTime
          : argruments?.transactionMethodType == TransactionMethodType.addProduct
          ? argruments?.addProductItems?.info?.createAtDateTime
          : null;

  String get transactionId => switch (argruments?.transactionMethodType) {
    TransactionMethodType.order => argruments?.orderItem?.id,
    TransactionMethodType.addProduct => argruments?.addProductItems?.id,
    TransactionMethodType.undefined => 'undefined',
    null => '',
  };

  void setArgruments(OrderCompleteArgrument? argruments) async {
    this.argruments = argruments;
    // await appCubit.loadProductByCurrentStore();
    emit(OrderCompleteInitial());
  }
}
