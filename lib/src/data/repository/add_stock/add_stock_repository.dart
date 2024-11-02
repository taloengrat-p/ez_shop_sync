import 'package:ez_shop_sync/src/data/dto/hive_object/transaction.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_transaction_request.dart';
import 'package:ez_shop_sync/src/data/repository/add_stock/add_stock_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/add_stock/add_stock_server_repository.dart';
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
class AddStockRepository implements ITransactionRepository {
  AddStockLocalRepository addStockLocalRepository;
  AddStockServerRepository addStockServerRepository;

  AddStockRepository({
    required this.addStockLocalRepository,
    required this.addStockServerRepository,
  });

  @override
  Future<Transaction> create(CreateTransactionRequest request) async {
    if (request.appMode == AppMode.local) {
      return await addStockLocalRepository.create(
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
      return await addStockLocalRepository.delete(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> deleteAll(BaseRepoRequest request) {
    if (request.appMode == AppMode.local) {
      return addStockLocalRepository.deleteAll();
    } else {
      throw UnimplementedError();
    }
  }

  Future<List<Transaction>> getAllByStoreId(BaseRepoRequest request) async {
    if (request.appMode == AppMode.local) {
      return addStockLocalRepository.getAll().where((e) => e.storeId == request.storeId).toList();
    } else {
      throw UnimplementedError();
    }
  }
}
