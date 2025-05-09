import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/i_repository.dart';
import 'package:ez_shop_sync/src/data/repository/tag/local/tag_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/tag/server/tag_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:injectable/injectable.dart';

// abstract class ITagRepository {
//   List<Tag> getAll({AppMode appMode = AppMode.local});
//   List<Tag> getAllByIds(List<String> ids, {AppMode appMode = AppMode.local});
//   Tag? getById(String id, {AppMode appMode = AppMode.local});
//   Future<Tag> create(Tag request, {AppMode appMode = ∏AppMode.local});
//   Future<Tag> update(String id, Tag updated, {AppMode appMode = AppMode.local});
//   delete(String id, {AppMode appMode = AppMode.local});
//   deleteAll(List<String> ids, {AppMode appMode = AppMode.local});
// }

@Singleton()
@Injectable()
class TagRepository extends IRepository<Tag> {
  TagLocalRepository tagLocalRepository;
  TagServerRepository tagServerRepository;

  TagRepository({required this.tagLocalRepository, required this.tagServerRepository, required super.navigationService})
    : super(AppMode.local);

  @override
  Future<ApiResult<Tag>> create(BaseRepoRequest<Tag> request) async {
    if (appMode == AppMode.local) {
      final result = await tagLocalRepository.create(request);

      result.when(
        success: (response) {
          ToastNotificationService.show(
            title: LocaleKeys.notification_createSuccess.tr(args: ['Tag ${response.name}']),
            // desc: LocaleKeys.notification_createSuccessSeeDetail.tr(),
            onTap: (value) {
              // ProductDetailRouter(GetIt.I<NavigationService>().navigatorKey.currentContext!).navigate(
              //   argruments: result,
              // );
            },
          );
        },
      );

      return result;
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> delete(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      return await tagLocalRepository.delete(request.data);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> deleteAll() async {
    if (appMode == AppMode.local) {
      return await tagLocalRepository.deleteAll();
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<Tag>>> getAll() {
    if (appMode == AppMode.local) {
      return tagLocalRepository.getAll();
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<Tag>>> getAllByIds(List<String> ids) {
    if (appMode == AppMode.local) {
      return tagLocalRepository.getAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<Tag>> getById(BaseRepoRequest<String> reqeust) async {
    if (appMode == AppMode.local) {
      return await tagLocalRepository.getById(reqeust.data);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<Tag>> update(BaseRepoRequest<Tag> request) async {
    if (appMode == AppMode.local) {
      final result = await tagLocalRepository.update(request);

      result.when(
        success: (response) {
          ToastNotificationService.show(title: LocaleKeys.notification_updateSuccess.tr(args: [response.name]));
        },
      );

      return result;
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> deleteAllByIds(List<String> ids) {
    // TODO: implement deleteAllByIds
    throw UnimplementedError();
  }
}
