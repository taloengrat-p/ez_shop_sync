import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/transaction/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCubit extends Cubit<TransactionState> {
  BaseCubit baseCubit;
  TransactionCubit({
    required this.baseCubit,
  }) : super(TransactionInitial());
}
