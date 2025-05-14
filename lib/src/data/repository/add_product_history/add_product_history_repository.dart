import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/pagination_index_request.dart';
import 'package:ez_shop_sync/src/data/dto/response/add_product_history_response.dart';
import 'package:ez_shop_sync/src/data/repository/add_product_history/server/add_product_history_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/i_repository.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/server/i_transaction_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';

import 'local/add_product_history_local_repository.dart';

@Singleton()
@Injectable()
class AddProductHistoryRepository extends IRepository<AddProduct> {
  AddProductHistoryLocalRepository addProductHistoryLocalRepository;
  IAddProductHistoryServerRepository addProductHistoryServerRepository;
  AddProductHistoryRepository({
    required this.addProductHistoryLocalRepository,
    required this.addProductHistoryServerRepository,
    required super.navigationService,
  }) : super(AppMode.server);

  Future<ApiResult<AddProduct>> create(BaseRepoRequest<AddProduct> request) async {
    if (appMode == AppMode.local) {
      return await addProductHistoryLocalRepository.create(request);
    } else {
      return await addProductHistoryServerRepository.createAddProductHistory(request);
    }
  }

  @override
  Future<ApiResult> delete(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      return await addProductHistoryLocalRepository.delete(request.data);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> deleteAllByIds(List<String> ids) async {
    if (appMode == AppMode.local) {
      return await addProductHistoryLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<AddProduct>>> getAllByIds(List<String> addProducts) async {
    if (appMode == AppMode.local) {
      return await addProductHistoryLocalRepository.getAllByIds(addProducts);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<AddProduct>> update(BaseRepoRequest<AddProduct> request) async {
    if (appMode == AppMode.local) {
      return await addProductHistoryLocalRepository.update(request);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult<List<AddProduct>>> getAllRange(BaseRepoRequest<DateRangeRequest> request) async {
    if (appMode == AppMode.local) {
      return Future.value(
        ApiResult(
          response: addProductHistoryLocalRepository.getAllRange(
            request.data.start.millisecondsSinceEpoch,
            request.data.start.millisecondsSinceEpoch,
          ),
        ),
      );
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<AddProduct>>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<AddProduct>> getById(BaseRepoRequest<String> request) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<ApiResult> deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  Future<ApiResult<AddProductHistoryResponse>> getItemsByLimit(BaseRepoRequest<PaginationIndexRequest> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return await addProductHistoryServerRepository.getItemsByLimit(request);
    }
  }

  Future<ApiResult<AddProduct>> getDetailById(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return await addProductHistoryServerRepository.getDetailById(request);
    }
  }
}
