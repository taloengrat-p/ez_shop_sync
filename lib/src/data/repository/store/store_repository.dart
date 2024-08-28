import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/repository/store/_local/store_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/_server/store_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';

abstract class IStoreRepository {
  List<Store> getAll();
  List<Store> getAllByIds(List<String> ids);
  Store? getById(String id);
  Future<Store> create(Store request);
  Future<Store> update(String id, Store updated);
  delete(String id);
  deleteAll(List<String> ids);
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
  Future<Store> create(Store request, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return storeLocalRepository.create(request);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  delete(String id, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
    } else {}
  }

  @override
  deleteAll(List<String> ids, {AppMode? appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      await storeLocalRepository.deleteAll(ids);
    } else {}
  }

  @override
  List<Store> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
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
}
