import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/category/local/category_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/category/server/category_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/i_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class CategoryRepository extends IRepository<Category> {
  final CategoryLocalRepository categoryLocalRepository;
  final CategoryServerRepository categoryServerRepository;

  CategoryRepository({required this.categoryLocalRepository, required this.categoryServerRepository})
    : super(AppMode.local);

  @override
  Future<ApiResult<Category>> create(BaseRepoRequest<Category> request) async {
    if (appMode == AppMode.local) {
      return await categoryLocalRepository.create(request);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> delete(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      return await categoryLocalRepository.delete(request.data);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> deleteAllByIds(List<String> ids) async {
    if (appMode == AppMode.local) {
      return await categoryLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<Category>>> getAll() async {
    if (appMode == AppMode.local) {
      return await categoryLocalRepository.getAll();
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<Category>>> getAllByIds(List<String> ids) async {
    if (appMode == AppMode.local) {
      return categoryLocalRepository.getAllById(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<Category>> getById(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      return await categoryLocalRepository.getById(request.data);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<Category>> update(BaseRepoRequest<Category> request) async {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_updateSuccess.tr(args: ['Category']));
      return await categoryLocalRepository.update(request);
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
