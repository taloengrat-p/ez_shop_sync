import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/branch.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/store_request/add_branch_request.dart';
import 'package:ez_shop_sync/src/pages/add_user/add_user_cubit.dart';

abstract class StoreServerRepository {
  Future<ApiResult<Store>> create(BaseRepoRequest<Store> request);

  Future<ApiResult<List<Store>>> getAll();

  Future<ApiResult> sendInviteToStore(BaseRepoRequest<StoreSendInvite> request);

  Future<ApiResult> acceptInvitation(String? notiId, String? storeId, Map<String, dynamic>? payload);

  Future<ApiResult> rejectInvitation();

  Future<ApiResult<Branch>> createBranch(BaseRepoRequest<AddBranchRequest> request);

  Future<ApiResult<List<Branch>>> getStoreBranches(BaseRepoRequest<Null> request);

  Future<ApiResult> deleteBranch(BaseRepoRequest request);

  Future<ApiResult<List<Branch>>> getAllBranchesByStoreIds(BaseRepoRequest<List<String>> request);
}
