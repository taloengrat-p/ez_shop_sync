import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/transaction.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_transaction_request.dart';
import 'package:ez_shop_sync/src/data/repository/i_repository.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/local/transaction_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/server/transaction_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

// abstract class ITransactionRepository {
//   Future<Transaction> create(CreateTransactionRequest request);
//   Future<void> delete(String id, {AppMode appMode = AppMode.local});
//   Future<void> deleteAll(BaseRepoRequest request);
// }

@Singleton()
@Injectable()
class TransactionRepository extends IRepository<Transaction> {
  TransactionLocalRepository transactionLocalRepository;
  TransactionServerRepository transactionServerRepository;

  TransactionRepository({
    required this.transactionLocalRepository,
    required this.transactionServerRepository,
    required super.navigationService,
  }) : super(AppMode.local);

  @override
  Future<ApiResult<Transaction>> create(BaseRepoRequest<Transaction> request) async {
    if (appMode == AppMode.local) {
      return await transactionLocalRepository.create(request);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult<Transaction>> createTransaction(CreateTransactionRequest request) async {
    if (appMode == AppMode.local) {
      return await transactionLocalRepository.create(
        BaseRepoRequest(
          storeId: request.storeId,
          userId: request.userId,
          data: Transaction(
            id: const Uuid().v1(),
            transactionType: request.transactionType.name,
            method: request.method.name,
            valueId: request.valueId,
            totalPrice: request.totalPrice,
            storeId: request.storeId,
          ),
        ),
      );
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> delete(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      return await transactionLocalRepository.delete(request.data);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> deleteAllByIds(List<String> request) async {
    if (appMode == AppMode.local) {
      return await transactionLocalRepository.deleteAll();
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult<List<Transaction>>> getAllByStoreId(String storeId) async {
    if (appMode == AppMode.local) {
      final result = await transactionLocalRepository.getAll();

      result.when(
        success: (response) {
          return ApiResult(response: response.where((e) => e.storeId == storeId).toList());
        },
        failure: (error) {
          return ApiResult(error: error);
        },
      );
    } else {
      throw UnimplementedError();
    }

    return ApiResult(error: 'getAllByStoreId failure');
  }

  @override
  Future<ApiResult<List<Transaction>>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<List<Transaction>>> getAllByIds(List<String> ids) {
    // TODO: implement getAllByIds
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Transaction>> getById(BaseRepoRequest<String> request) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Transaction>> update(request) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<ApiResult> deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }
}
