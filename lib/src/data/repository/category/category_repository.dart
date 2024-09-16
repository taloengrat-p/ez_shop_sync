import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/repository/base_repository.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:injectable/injectable.dart';

abstract class ICategoryRepository {
  List<Category> getAll({AppMode appMode = AppMode.local});
  List<Category> getAllByIds(List<String> ids, {AppMode appMode = AppMode.local});
  Category? getById(String id, {AppMode appMode = AppMode.local});
  Future<Category> create(Category request, {AppMode appMode = AppMode.local});
  Future<Category> update(String id, Category updated, {AppMode appMode = AppMode.local});
  Future<void> delete(String id, {AppMode appMode = AppMode.local});
  Future<void> deleteAll(List<String> ids, {AppMode appMode = AppMode.local});
}

@Singleton()
@Injectable()
class CategoryRepository extends BaseRepository implements ICategoryRepository {
  CategoryLocalRepository categoryLocalRepository;
  CategoryServerRepository categoryServerRepository;

  CategoryRepository({
    required this.categoryLocalRepository,
    required this.categoryServerRepository,
  });

  @override
  Future<Category> create(Category request, {AppMode appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      return await categoryLocalRepository.create(request);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> delete(String id, {AppMode appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      await categoryLocalRepository.delete(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> deleteAll(List<String> ids, {AppMode appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      await categoryLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  List<Category> getAll({AppMode appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return categoryLocalRepository.getAll();
    } else {
      throw UnimplementedError();
    }
  }

  @override
  List<Category> getAllByIds(List<String> ids, {AppMode appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return categoryLocalRepository.getAllById(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Category? getById(String id, {AppMode appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return categoryLocalRepository.getById(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<Category> update(String id, Category updated, {AppMode appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_updateSuccess.tr(args: [updated.name]));
      return await categoryLocalRepository.update(id, updated);
    } else {
      throw UnimplementedError();
    }
  }
}
