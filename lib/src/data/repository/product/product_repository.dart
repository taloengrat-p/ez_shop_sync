import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/product_history_event.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_method_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_history.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_qty_to_stock_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_history_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_transaction_request.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product_history/product_history_repository.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/transaction_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_router.dart';
import 'package:ez_shop_sync/src/services/navigation_service.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

abstract class IProductRepository {
  List<Product> getAll({AppMode appMode = AppMode.local});
  Future<ApiResult<Product>> getById(
      {required String storeId,
      required String productId,
      AppMode appMode = AppMode.local});
  Future<Product?> create(CreateProductRequest request);
  Future<ApiResult<Product>> update(
      String storeId, String productId, Product updated,
      {AppMode appMode = AppMode.local});
  Future<void> delete(String storeId, String id,
      {AppMode appMode = AppMode.local});
  Future<void> deleteAll(List<String> ids, {AppMode appMode = AppMode.local});
  Future<ApiResult<List<Product>?>> getAllByStoreId(String id,
      {AppMode appMode = AppMode.local});
}

@Singleton()
@Injectable()
class ProductRepository implements IProductRepository {
  String name = '';

  ProductLocalRepository productLocalRepository;
  ProductServerRepository productServerRepository;
  ProductHistoryRepository productHistoryRepository;
  TransactionRepository transactionRepository;

  ProductRepository({
    required this.productLocalRepository,
    required this.productServerRepository,
    required this.productHistoryRepository,
    required this.transactionRepository,
  });

  @override
  Future<Product?> create(CreateProductRequest request) async {
    if (request.appMode == AppMode.local) {
      final result = await productLocalRepository.create(request.product);

      await productHistoryRepository.create(
        CreateProductHistoryRequest(
            storeId: request.storeId,
            userId: request.userId,
            event: ProductHistoryEvent.create,
            productId: result.id,
            newData: {},
            info: BaseHiveData(
                createAt: DateTime.now(), updateAt: DateTime.now())),
      );

      ToastNotificationService.show(
        title: LocaleKeys.notification_createSuccess.tr(
          args: [result.name],
        ),
        desc: LocaleKeys.notification_createSuccessSeeDetail.tr(),
        onTap: (value) {
          ProductDetailRouter(
                  GetIt.I<NavigationService>().navigatorKey.currentContext!)
              .navigate(
            argruments: result,
          );
        },
      );

      return result;
    } else {
      final result = await productServerRepository.create(request.product);

      return result.response;
    }
  }

  @override
  Future<void> delete(String storeId, String id,
      {AppMode? appMode = AppMode.local, String? name}) async {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(
          title: LocaleKeys.notification_deleteSuccess.tr(args: [name ?? '']));
      return productLocalRepository.delete(id);
    } else {
      await productServerRepository.delete(storeId: storeId, productId: id);

      ToastNotificationService.show(
          title: LocaleKeys.notification_deleteSuccess.tr(args: [name ?? '']));
    }
  }

  @override
  deleteAll(List<String> ids, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(
          title: LocaleKeys.notification_deleteSuccess.tr());
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

  Future<ApiResult<List<Product>>> getByIds(String storeId, List<String> ids,
      {AppMode? appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      final products = productLocalRepository.getAllById(ids);
      return Future.value(ApiResult(response: products));
    } else {
      return await productServerRepository.getAllByIds(
          storeId: storeId, productIds: ids);
    }
  }

  @override
  Future<ApiResult<Product>> getById(
      {required String storeId,
      required String productId,
      AppMode? appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      final product = productLocalRepository.getById(productId);
      return Future.value(ApiResult(response: product));
    } else {
      return await productServerRepository.getProduct(
          storeId: storeId, productId: productId);
    }
  }

  @override
  Future<ApiResult<Product>> update(String storeId, String id, Product updated,
      {AppMode? appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(
          title:
              LocaleKeys.notification_updateSuccess.tr(args: [updated.name]));
      final resultLocal = await productLocalRepository.update(id, updated);

      return ApiResult(response: resultLocal);
    } else {
      final response = await productServerRepository.update(
          storeId: storeId, productId: id, updated);

      ToastNotificationService.show(
          title:
              LocaleKeys.notification_updateSuccess.tr(args: [updated.name]));

      return response;
    }
  }

  @override
  Future<ApiResult<List<Product>?>> getAllByStoreId(String id,
      {AppMode? appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      return productLocalRepository.getAllByStoreId(id);
    } else {
      return productServerRepository.getAllByStoreId(id);
    }
  }

  Future<ApiResult<Product>> addProductQuantityToStock(
    AddProductQtyToStockrequest request, {
    AppMode? appMode = AppMode.local,
  }) async {
    if (appMode == AppMode.local) {
      final product =
          await getById(storeId: request.storeId, productId: request.productId);

      if (product == null) {
        throw ('Product ${request.productId} is Null');
      }

      final newQuantity =
          (product.response?.quantity ?? 0) + (request.product.quantity ?? 0);

      final productUpdated = await update(request.storeId, product.response!.id,
          product.response!..quantity = newQuantity);

      final productHistory = await productHistoryRepository.create(
        CreateProductHistoryRequest(
            productId: product.response!.id,
            storeId: product.response!.storeId,
            userId: request.userId,
            event: ProductHistoryEvent.addToStock,
            newData: {
              "priceCategory": request.product.priceSelected,
              "qty": request.product.quantity,
            },
            info: BaseHiveData(
                createAt: DateTime.now(), updateAt: DateTime.now())),
      );

      await transactionRepository.create(
        CreateTransactionRequest(
          storeId: request.storeId,
          userId: request.userId,
          method: TransactionMethodType.addProduct,
          totalPrice: request.amountCost,
          transactionType: TransactionType.expenses,
          valueId: productHistory.id,
        ),
      );

      return productUpdated;
    } else {
      throw UnimplementedError();
    }
  }

  Future<void> orderCompletedUpdate(Cart? cart,
      {AppMode? appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      for (OrderItem item in cart?.cartItems ?? []) {
        if (item.product?.id != null) {
          final product = await getById(
              storeId: cart!.storeId, productId: item.product!.id);

          if (product == null) {
            throw ('Product ${item.product!.id} is Null');
          }

          final newQuantity =
              (product.response?.quantity ?? 0) - (item.product?.quantity ?? 0);

          await productLocalRepository.update(
              product.response?.id, product.response!..quantity = newQuantity);
        }
      }
    } else {
      throw UnimplementedError();
    }
  }

  Future<void> updateHistory(CreateProductHistoryRequest request) async {
    await productServerRepository.updateHistory(request);
  }

  Future<void> reduceQuantity({
    required String storeId,
    required productId,
    String? productTypeId,
    required num reduceQty,
  }) async {
    await productServerRepository.reduceQuantity(
      storeId: storeId,
      productId: productId,
      productTypeId: productTypeId,
      reduceQty: reduceQty,
    );
  }

  Future<ApiResult<List<ProductHistory>>> getProductHistory(
      {required String productId, required String storeId, int? limit}) async {
    return await productServerRepository.getProductHistory(
      productId: productId,
      storeId: storeId,
      limit: limit,
    );
  }
}
