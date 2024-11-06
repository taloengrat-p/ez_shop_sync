import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:injectable/injectable.dart';

abstract class IStoreRepository {
  Future<ApiResult<List<Store>>> getAll({AppMode appMode = AppMode.local});
  List<Store> getAllByIds(List<String> ids, {AppMode appMode = AppMode.local});
  Store? getById(String id, {AppMode appMode = AppMode.local});
  Future<ApiResult<Store>> create(Store request, {AppMode appMode = AppMode.local});
  Future<Store> update(String id, Store updated, {AppMode appMode = AppMode.local});
  Future<void> delete(String id, {AppMode appMode = AppMode.local});
  deleteAll(List<String> ids, {AppMode appMode = AppMode.local});
}

@Singleton()
@Injectable()
class StoreRepository implements IStoreRepository {
  StoreLocalRepository storeLocalRepository;
  StoreServerRepository storeServerRepository;

  StoreRepository({
    required this.storeLocalRepository,
    required this.storeServerRepository,
  });

  @override
  Future<ApiResult<Store>> create(Store request, {AppMode? appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      final storeCreated = await storeLocalRepository.create(request);
      // ToastNotificationService.show(
      //   title: LocaleKeys.notification_createSuccess.tr(
      //     args: [storeCreated.name],
      //   ),
      //   desc: LocaleKeys.notification_createSuccessSeeDetail.tr(),
      //   onTap: (value) {
      //     StoreManagementRouter(GetIt.I<NavigationService>().navigatorKey.currentContext!).navigate();
      //   },
      // );

      return ApiResult(response: storeCreated);
    } else {
      return await storeServerRepository.create(request);
    }
  }

  @override
  Future<void> delete(String id, {AppMode? appMode = AppMode.local, String? name}) async {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(
        title: LocaleKeys.notification_deleteSuccess.tr(
          args: [name ?? ''],
        ),
      );
      await storeLocalRepository.delete(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  deleteAll(List<String> ids, {AppMode? appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      await storeLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<Store>>> getAll({AppMode appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      return Future.value(ApiResult(response: []));
    } else {
      return await storeServerRepository.getAll();
    }
  }

  @override
  Store? getById(String id, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return storeLocalRepository.getById(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<Store> update(String id, Store updated, {AppMode? appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_updateSuccess.tr(args: [updated.name]));
      return storeLocalRepository.update(id, updated);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  List<Store> getAllByIds(List<String> ids, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return storeLocalRepository.getAllById(ids);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult> acceptInvitation() async {
    
  }

  Future<ApiResult> rejectInvitation() async {}
}
