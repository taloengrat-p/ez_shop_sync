import 'package:ez_shop_sync/src/data/dto/hive_object/transaction.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_transaction_request.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/transaction_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/transaction_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

abstract class ITransactionRepository {
  Future<Transaction> create(CreateTransactionRequest request);
  Future<void> delete(String id, {AppMode appMode = AppMode.local});
  Future<void> deleteAll(BaseRepoRequest request);
}

@Singleton()
@Injectable()
class TransactionRepository implements ITransactionRepository {
  TransactionLocalRepository transactionLocalRepository;
  TransactionServerRepository transactionServerRepository;

  TransactionRepository({
    required this.transactionLocalRepository,
    required this.transactionServerRepository,
  });

  @override
  Future<Transaction> create(CreateTransactionRequest request) async {
    if (request.appMode == AppMode.local) {
      return await transactionLocalRepository.create(
        Transaction(
          id: const Uuid().v1(),
          transactionType: request.transactionType.name,
          method: request.method.name,
          valueId: request.valueId,
          totalPrice: request.totalPrice,
          storeId: request.storeId,
        ),
        userId: request.userId,
      );
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> delete(String id, {AppMode appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      return await transactionLocalRepository.delete(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> deleteAll(BaseRepoRequest request) {
    if (request.appMode == AppMode.local) {
      return transactionLocalRepository.deleteAll();
    } else {
      throw UnimplementedError();
    }
  }

  Future<List<Transaction>> getAllByStoreId(BaseRepoRequest request) async {
    if (request.appMode == AppMode.local) {
      return transactionLocalRepository.getAll().where((e) => e.storeId == request.storeId).toList();
    } else {
      throw UnimplementedError();
    }
  }
}
