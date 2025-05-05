import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/transaction/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class TransactionCubit extends Cubit<TransactionState> {
  final AppCubit appCubit;

  TransactionCubit({required this.appCubit}) : super(TransactionInitial());
}
