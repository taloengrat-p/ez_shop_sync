// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/branch.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/unit_type.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/store_request/add_branch_request.dart';
import 'package:ez_shop_sync/src/data/repository/i_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/i_store_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/local/store_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/server/store_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/pages/add_user/add_user_cubit.dart';
import 'package:ez_shop_sync/src/pages/store_management/store_management_router.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:injectable/injectable.dart';
import 'package:toastification/toastification.dart';

@Singleton()
@Injectable()
class StoreRepository extends IRepository<Store> implements IStoreRepository {
  final StoreLocalRepository storeLocalRepository;
  final StoreServerRepository storeServerRepository;

  StoreRepository({
    required this.storeLocalRepository,
    required this.storeServerRepository,
    required super.navigationService,
  }) : super(AppMode.server);

  @override
  Future<ApiResult<Store>> create(BaseRepoRequest<Store> request) async {
    final ApiResult<Store> result;
    if (appMode == AppMode.local) {
      result = await storeLocalRepository.create(request);
    } else {
      result = await storeServerRepository.create(request);
    }

    result.when(
      success: (response) {
        showToast(
          title: LocaleKeys.notification_createSuccess.tr(args: [response.name]),
          type: ToastificationType.success,
          onTap: (context, item) {
            StoreManagementRouter(context!).navigate();
          },
        );
      },
      failure: (error) {
        showToast(
          title: LocaleKeys.notification_createSuccess.tr(args: [request.data.name]),
          desc: LocaleKeys.notification_createSuccessSeeDetail.tr(),
          type: ToastificationType.error,
          onTap: (context, item) {
            StoreManagementRouter(context!).navigate();
          },
        );
      },
    );

    return result;
  }

  @override
  Future<ApiResult> delete(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_deleteSuccess.tr(args: ['Store']));
      return await storeLocalRepository.delete(request.data);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> deleteAllByIds(List<String> ids) async {
    if (appMode == AppMode.local) {
      return await storeLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<Store>>> getAll() async {
    if (appMode == AppMode.local) {
      return Future.value(ApiResult(response: []));
    } else {
      return await storeServerRepository.getAll();
    }
  }

  @override
  Future<ApiResult<Store>> getById(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      return await storeLocalRepository.getById(request.data);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<Store>> update(BaseRepoRequest<Store> request) async {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_updateSuccess.tr(args: ['Store']));
      return await storeLocalRepository.update(request);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<Store>>> getAllByIds(List<String> ids) async {
    if (appMode == AppMode.local) {
      return await storeLocalRepository.getAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> deleteAll() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Branch>> createBranch(BaseRepoRequest<AddBranchRequest> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return await storeServerRepository.createBranch(request);
    }
  }

  @override
  Future<ApiResult> sendInviteToStore(BaseRepoRequest<StoreSendInvite> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return await storeServerRepository.sendInviteToStore(request);
    }
  }

  @override
  Future<ApiResult<List<Branch>>> getStoreBranches(BaseRepoRequest<Null> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return await storeServerRepository.getStoreBranches(request);
    }
  }

  @override
  Future<ApiResult> deleteBranch(BaseRepoRequest request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return await storeServerRepository.deleteBranch(request);
    }
  }

  @override
  Future<ApiResult<List<Branch>>> getAllBranchesByStoreIds(BaseRepoRequest<List<String>> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return await storeServerRepository.getAllBranchesByStoreIds(request);
    }
  }

  @override
  Future<ApiResult> deleteUnitTypeByIds(BaseRepoRequest<List<String>> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return await storeServerRepository.deleteUnitTypeByIds(request);
    }
  }

  @override
  Future<ApiResult<List<UnitType>>> getUnitTypes(BaseRepoRequest<Null> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return await storeServerRepository.getUnitTypes(request);
    }
  }

  @override
  Future<ApiResult<UnitType>> createUnitTypes(BaseRepoRequest<UnitType> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return await storeServerRepository.createUnitTypes(request);
    }
  }

  @override
  Future<ApiResult> updateUnitType(BaseRepoRequest<UnitType> payload) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return await storeServerRepository.updateUnitType(payload);
    }
  }
}
