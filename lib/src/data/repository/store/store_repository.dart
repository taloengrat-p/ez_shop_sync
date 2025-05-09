// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/i_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/local/dev_store_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/server/dev_store_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/pages/store_management/store_management_router.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:injectable/injectable.dart';
import 'package:toastification/toastification.dart';

@Singleton()
@Injectable()
class StoreRepository extends IRepository<Store> {
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
    // TODO: implement deleteAll
    throw UnimplementedError();
  }
}
