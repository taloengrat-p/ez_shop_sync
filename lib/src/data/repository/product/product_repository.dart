import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/product_history_event.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_qty_to_stock_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_history_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_request.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product_history/product_history_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_router.dart';
import 'package:ez_shop_sync/src/services/navigation_service.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

abstract class IProductRepository {
  List<Product> getAll({AppMode appMode = AppMode.local});
  Product? getById(String id, {AppMode appMode = AppMode.local});
  Future<Product> create(CreateProductRequest request);
  Future<Product> update(String id, Product updated, {AppMode appMode = AppMode.local});
  Future<void> delete(String id, {AppMode appMode = AppMode.local});
  Future<void> deleteAll(List<String> ids, {AppMode appMode = AppMode.local});
  List<Product> getAllByStoreId(String id, {AppMode appMode = AppMode.local});
}

@Singleton()
@Injectable()
class ProductRepository implements IProductRepository {
  String name = '';

  ProductLocalRepository productLocalRepository;
  ProductServerRepository productServerRepository;
  ProductHistoryRepository productHistoryRepository;

  ProductRepository({
    required this.productLocalRepository,
    required this.productServerRepository,
    required this.productHistoryRepository,
  });

  @override
  Future<Product> create(CreateProductRequest request) async {
    if (request.appMode == AppMode.local) {
      final result = await productLocalRepository.create(request.product);

      await productHistoryRepository.create(
        CreateProductHistoryRequest(
          id: const Uuid().v1(),
          storeId: request.storeId,
          userId: request.userId,
          event: ProductHistoryEvent.create,
          productId: request.id,
          newData: {},
        ),
      );

      ToastNotificationService.show(
        title: LocaleKeys.notification_createSuccess.tr(
          args: [result.name],
        ),
        desc: LocaleKeys.notification_createSuccessSeeDetail.tr(),
        onTap: (value) {
          ProductDetailRouter(GetIt.I<NavigationService>().navigatorKey.currentContext!).navigate(
            argruments: result,
          );
        },
      );

      return result;
    } else {
      throw UnimplementedError();
    }
  }

  @override
  delete(String id, {AppMode? appMode = AppMode.local, String? name}) {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_deleteSuccess.tr(args: [name ?? '']));
      return productLocalRepository.delete(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  deleteAll(List<String> ids, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_deleteSuccess.tr());
      return productLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  List<Product> getAll({AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return productLocalRepository.getAll();
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Product? getById(String id, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return productLocalRepository.getById(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<Product> update(String id, Product updated, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_updateSuccess.tr(args: [updated.name]));
      return productLocalRepository.update(id, updated);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  List<Product> getAllByStoreId(String id, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return productLocalRepository.getAllByStoreId(id);
    } else {
      throw UnimplementedError();
    }
  }

  Future<Product?> addProductQuantityToStock(AddProductQtyToStockrequest request) async {
    final product = getById(request.id);

    if (product == null) {
      throw ('Product ${request.id} is Null');
    }

    final newQuantity = (product.quantity ?? 0) + (request.product.quantity ?? 0);

    final productUpdated = await update(product.id, product..quantity = newQuantity);

    await productHistoryRepository.create(
      CreateProductHistoryRequest(
        id: const Uuid().v1(),
        productId: product.id,
        storeId: product.storeId,
        userId: request.userId,
        event: ProductHistoryEvent.addToStock,
        newData: {
          "priceCategory": request.product.priceSelected,
          "qty": request.product.quantity,
        },
      ),
    );

    return productUpdated;
  }
}
