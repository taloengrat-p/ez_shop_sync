import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/product/_local/product_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/_server/product_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_router.dart';
import 'package:ez_shop_sync/src/services/navigation_service.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

abstract class IProductRepository {
  List<Product> getAll();
  Product? getById(String id);
  Future<Product> create(Product request);
  Future<Product> update(String id, Product updated);
  Future<void> delete(String id);
  Future<void> deleteAll(List<String> ids);
  List<Product> getAllByStoreId(String id);
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
  Future<Product> create(Product request, {AppMode? appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      final result = await productLocalRepository.create(request);

      ToastNotificationService.show(
        title: LocaleKeys.notification_createProductSuccessTitle.tr(
          args: [result.name],
        ),
        desc: LocaleKeys.notification_createProductSuccessDesc.tr(),
        onTap: (value) {
          ProductDetailRouter(GetIt.I<NavigationService>().navigatorKey.currentContext!).navigate(
            argruments: result,
          );
        },
      );

      return result;
    } else {
      return productServerRepository.create(request);
    }
  }

  @override
  delete(String id, {AppMode? appMode = AppMode.local, String? name}) {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_deleteSuccess.tr(args: [name ?? '']));
      return productLocalRepository.delete(id);
    } else {
      return productServerRepository.delete(id);
    }
  }

  @override
  deleteAll(List<String> ids, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_deleteSuccess.tr());
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
  Future<Product> update(String id, Product updated, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_updateSuccess.tr());
      return productLocalRepository.update(id, updated);
    } else {
      return productServerRepository.update(id, updated);
    }
  }

  @override
  List<Product> getAllByStoreId(String id, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return productLocalRepository.getAllByStoreId(id);
    } else {
      throw ('no implement');
    }
  }
}
