import 'package:ez_shop_sync/src/pages/transaction_statement_detail/transaction_statement_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionStatementDetailCubit extends Cubit<TransactionStatementDetailState> {
  TransactionStatementDetailArgrument? argruments;
  TransactionStatementDetailCubit() : super(TransactionStatementDetailInitial());

  void initialize(TransactionStatementDetailArgrument argruments) {
    this.argruments = argruments;
    emit(TransactionStatementDetailInitial());
  }
}
