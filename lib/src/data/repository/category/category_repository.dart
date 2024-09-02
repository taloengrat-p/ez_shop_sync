import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/repository/base_repository.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';

abstract class ICategoryRepository {
  List<Category> getAll();
  List<Category> getAllByIds(List<String> ids);
  Category? getById(String id);
  Future<Category> create(Category request);
  Future<Category> update(String id, Category updated);
  delete(String id);
  deleteAll(List<String> ids);
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
  Future<Category> create(Category request) async {
    if (appMode == AppMode.local) {
      return await categoryLocalRepository.create(request);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  delete(String id) async {
    if (appMode == AppMode.local) {
      await categoryLocalRepository.delete(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  deleteAll(List<String> ids) async {
    if (appMode == AppMode.local) {
      await categoryLocalRepository.deleteAll(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  List<Category> getAll() {
    if (appMode == AppMode.local) {
      return categoryLocalRepository.getAll();
    } else {
      throw UnimplementedError();
    }
  }

  @override
  List<Category> getAllByIds(List<String> ids) {
    if (appMode == AppMode.local) {
      return categoryLocalRepository.getAllById(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Category? getById(String id) {
    if (appMode == AppMode.local) {
      return categoryLocalRepository.getById(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<Category> update(String id, Category updated) async {
    if (appMode == AppMode.local) {
      return await categoryLocalRepository.update(id, updated);
    } else {
      throw UnimplementedError();
    }
  }
}
