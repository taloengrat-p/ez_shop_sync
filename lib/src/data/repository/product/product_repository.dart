import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/product/_local/product_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/_server/product_server_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:injectable/injectable.dart';

abstract class IProductRepository {
  List<Product> getAll();
  Product getDetail(String id);
  Future<Product> create(Product request);
  Product update(String id, Product updated);
  delete(String id);
  deleteAll();
}

@Singleton()
@Injectable()
class ProductRepository implements IProductRepository {
  BaseCubit baseCubit;
  ProductLocalRepository productLocalRepository;
  ProductServerRepository productServerRepository;

  ProductRepository({
    required this.baseCubit,
    required this.productLocalRepository,
    required this.productServerRepository,
  });
  @override
  Future<Product> create(Product request) {
    if (baseCubit.appMode == AppMode.local) {
      return productLocalRepository.create(request);
    } else {
      return productServerRepository.create(request);
    }
  }

  @override
  delete(String id) {
    if (baseCubit.appMode == AppMode.local) {
      return productLocalRepository.delete(id);
    } else {
      return productServerRepository.delete(id);
    }
  }

  @override
  deleteAll() {
    if (baseCubit.appMode == AppMode.local) {
      return productLocalRepository.deleteAll();
    } else {
      return productServerRepository.deleteAll();
    }
  }

  @override
  List<Product> getAll() {
    if (baseCubit.appMode == AppMode.local) {
      return productLocalRepository.getAll();
    } else {
      return productServerRepository.getAll();
    }
  }

  @override
  Product getDetail(String id) {
    if (baseCubit.appMode == AppMode.local) {
      return productLocalRepository.getDetail(id);
    } else {
      return productServerRepository.getDetail(id);
    }
  }

  @override
  Product update(String id, Product updated) {
    if (baseCubit.appMode == AppMode.local) {
      return productLocalRepository.update(id, updated);
    } else {
      return productServerRepository.update(id, updated);
    }
  }
}
