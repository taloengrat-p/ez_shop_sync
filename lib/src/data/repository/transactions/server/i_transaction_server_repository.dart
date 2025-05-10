// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/transaction.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_transaction_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/pagination_index_request.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/transaction_repository.dart';

abstract class ITransactionServerRepository {
  Future<ApiResult<Transaction>> create(BaseRepoRequest<CreateTransactionRequest> request);

  Future<ApiResult<List<Transaction>>> getByDateRange(BaseRepoRequest<DateRangeRequest> request);

  Future<ApiResult<TransactionStatementResponse>> getItemsByLimit(BaseRepoRequest<PaginationIndexRequest> request);
}

class DateRangeRequest {
  DateTime start;
  DateTime end;
  DateRangeRequest({required this.start, required this.end});
}
