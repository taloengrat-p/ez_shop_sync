import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/product/_local/product_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/_server/product_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';

abstract class IProductRepository {
  List<Product> getAll();
  Product? getById(String id);
  Future<Product> create(Product request);
  Product update(String id, Product updated);
  delete(String id);
  deleteAll(List<String> ids);
}

@Singleton()
@Injectable()
class ProductRepository implements IProductRepository {
  String name = '';

  ProductLocalRepository productLocalRepository;

  ProductServerRepository productServerRepository;

  ProductRepository({
    required this.productLocalRepository,
    required this.productServerRepository,
  });
  @override
  Future<Product> create(Product request, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return productLocalRepository.create(request);
    } else {
      return productServerRepository.create(request);
    }
  }

  @override
  delete(String id, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return productLocalRepository.delete(id);
    } else {
      return productServerRepository.delete(id);
    }
  }

  @override
  deleteAll(List<String> ids, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return productLocalRepository.deleteAll(ids);
    } else {
      return productServerRepository.deleteAll(ids);
    }
  }

  @override
  List<Product> getAll({AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return productLocalRepository.getAll();
    } else {
      return productServerRepository.getAll();
    }
  }

  @override
  Product? getById(String id, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return productLocalRepository.getById(id);
    } else {
      return productServerRepository.getById(id);
    }
  }

  @override
  Product update(String id, Product updated,
      {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return productLocalRepository.update(id, updated);
    } else {
      return productServerRepository.update(id, updated);
    }
  }
}
