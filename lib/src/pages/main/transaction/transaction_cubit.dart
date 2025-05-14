import 'package:cloud_firestore/cloud_firestore.dart' show QueryDocumentSnapshot;
import 'package:ez_shop_sync/src/data/dto/hive_object/transaction.dart';
import 'package:ez_shop_sync/src/data/dto/request/pagination_index_request.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/transaction_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/transaction/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class TransactionCubit extends Cubit<TransactionState> {
  final AppCubit appCubit;
  final TransactionRepository transactionRepository;
  final int itemLength = 10;
  QueryDocumentSnapshot? lastDocument;
  List<Transaction> transactions = [];
  TransactionCubit({required this.appCubit, required this.transactionRepository}) : super(TransactionInitial());

  void initialize() async {
    emit(TransactionInitialLoading());
    final result = await transactionRepository.getItemByLimit(
      appCubit.request(PaginationIndexRequest(start: 0, limit: itemLength)),
    );

    result.when(
      success: (response) {
        transactions = response.transactions;
        emit(TransactionSuccess());
      },
      failure: (error) {
        emit(const TransactionFailure());
      },
    );
  }

  Future<void> refresh() async {
    final start = transactions.length;

    final result = await transactionRepository.getItemByLimit(
      appCubit.request(PaginationIndexRequest(start: start, limit: itemLength)),
    );

    result.when(
      success: (response) {
        transactions = response.transactions;
        emit(TransactionSuccess());
      },
      failure: (error) {
        emit(const TransactionFailure());
      },
    );
  }

  Future<void> loadMoreItems({bool refresh = false, bool disabledState = false}) async {
    if (!disabledState) {
      emit(TransactionLoadmore());
    }
    final start = transactions.length;

    final orderLoaded = await transactionRepository.getItemByLimit(
      appCubit.request(
        PaginationIndexRequest(start: start, lastDocument: refresh ? null : lastDocument, limit: itemLength),
      ),
    );

    orderLoaded.when(
      success: (response) {
        lastDocument = response.lastDocument;
        transactions.addAll(response.transactions);

        emit(OrderHistoryLoadMoreSuccess(start: start, end: itemLength));
      },
      failure: (error) {
        emit(OrderHistoryLoadMoreFailure());
      },
    );
  }
}
