import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/repository/base_repository.dart';
import 'package:ez_shop_sync/src/data/repository/tag/tag_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/tag/tag_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:injectable/injectable.dart';

abstract class ITagRepository {
  List<Tag> getAll({AppMode appMode = AppMode.local});
  List<Tag> getAllByIds(List<String> ids, {AppMode appMode = AppMode.local});
  Tag? getById(String id, {AppMode appMode = AppMode.local});
  Future<Tag> create(Tag request, {AppMode appMode = AppMode.local});
  Future<Tag> update(String id, Tag updated, {AppMode appMode = AppMode.local});
  delete(String id, {AppMode appMode = AppMode.local});
  deleteAll(List<String> ids, {AppMode appMode = AppMode.local});
}

@Singleton()
@Injectable()
class TagRepository extends BaseRepository implements ITagRepository {
  TagLocalRepository tagLocalRepository;
  TagServerRepository tagServerRepository;

  TagRepository({
    required this.tagLocalRepository,
    required this.tagServerRepository,
  });

  @override
  Future<Tag> create(Tag request, {AppMode appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      final result = await tagLocalRepository.create(request);
      ToastNotificationService.show(
        title: LocaleKeys.notification_createSuccess.tr(
          args: [result.name],
        ),
        // desc: LocaleKeys.notification_createSuccessSeeDetail.tr(),
        onTap: (value) {
          // ProductDetailRouter(GetIt.I<NavigationService>().navigatorKey.currentContext!).navigate(
          //   argruments: result,
          // );
        },
      );
      return result;
    } else {
      throw UnimplementedError();
    }
  }

  @override
  delete(String id, {AppMode appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      await tagLocalRepository.delete(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  deleteAll(List<String> ids, {AppMode appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      await tagLocalRepository.deleteAll(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  List<Tag> getAll({AppMode appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return tagLocalRepository.getAll();
    } else {
      throw UnimplementedError();
    }
  }

  @override
  List<Tag> getAllByIds(List<String> ids, {AppMode appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return tagLocalRepository.getAllById(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Tag? getById(String id, {AppMode appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return tagLocalRepository.getById(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<Tag> update(String id, Tag updated, {AppMode appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_updateSuccess.tr(args: [updated.name]));
      return await tagLocalRepository.update(id, updated);
    } else {
      throw UnimplementedError();
    }
  }
}
