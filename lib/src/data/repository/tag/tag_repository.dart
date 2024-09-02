import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/repository/base_repository.dart';
import 'package:ez_shop_sync/src/data/repository/tag/tag_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/tag/tag_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';

abstract class ITagRepository {
  List<Tag> getAll();
  List<Tag> getAllByIds(List<String> ids);
  Tag? getById(String id);
  Future<Tag> create(Tag request);
  Future<Tag> update(String id, Tag updated);
  delete(String id);
  deleteAll(List<String> ids);
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
  Future<Tag> create(Tag request) async {
    if (appMode == AppMode.local) {
      return await tagLocalRepository.create(request);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  delete(String id) async {
    if (appMode == AppMode.local) {
      await tagLocalRepository.delete(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  deleteAll(List<String> ids) async {
    if (appMode == AppMode.local) {
      await tagLocalRepository.deleteAll(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  List<Tag> getAll() {
    if (appMode == AppMode.local) {
      return tagLocalRepository.getAll();
    } else {
      throw UnimplementedError();
    }
  }

  @override
  List<Tag> getAllByIds(List<String> ids) {
    if (appMode == AppMode.local) {
      return tagLocalRepository.getAllById(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Tag? getById(String id) {
    if (appMode == AppMode.local) {
      return tagLocalRepository.getById(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<Tag> update(String id, Tag updated) async {
    if (appMode == AppMode.local) {
      return await tagLocalRepository.update(id, updated);
    } else {
      throw UnimplementedError();
    }
  }
}
