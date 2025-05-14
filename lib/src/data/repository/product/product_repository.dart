import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/product_history_event.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_history.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_qty_to_stock_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_history_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/pagination_index_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/product_request/update_product_image_request.dart';
import 'package:ez_shop_sync/src/data/dto/response/pagination_response.dart';
import 'package:ez_shop_sync/src/data/repository/i_repository.dart';
import 'package:ez_shop_sync/src/data/repository/image/image_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/i_product_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/local/i_product_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/server/i_product_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product_history/product_history_repository.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/transaction_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:injectable/injectable.dart';
import 'package:toastification/toastification.dart';

@Singleton()
@Injectable()
class ProductRepository extends IRepository<Product> implements IProductRepository {
  IProductLocalRepository productLocalRepository;
  IProductServerRepository productServerRepository;
  ProductHistoryRepository productHistoryRepository;
  TransactionRepository transactionRepository;
  ImageRepository imageRepository;

  ProductRepository({
    required this.productLocalRepository,
    required this.productServerRepository,
    required this.productHistoryRepository,
    required this.transactionRepository,
    required super.navigationService,
    required this.imageRepository,
  }) : super(AppMode.server, tag: 'Product');

  @override
  Future<ApiResult> delete(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_deleteSuccess.tr(args: [tag]));
      return productLocalRepository.delete(request.data);
    } else {
      final result = await productServerRepository.delete(request);

      ToastNotificationService.show(title: LocaleKeys.notification_deleteSuccess.tr(args: [tag]));
      return result;
    }
  }

  @override
  deleteAllByIds(List<String> ids) {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_deleteSuccess.tr());
      return productLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<Product>>> getAll() async {
    if (appMode == AppMode.local) {
      return productLocalRepository.getAll();
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult<List<Product>>> getByIds(String? storeId, List<String> ids) async {
    if (appMode == AppMode.local) {
      return await productLocalRepository.getAllByIds(ids);
    } else {
      return await productServerRepository.getAllByIds(storeId: storeId ?? '', productIds: ids);
    }
  }

  @override
  Future<ApiResult<Product>> getById(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      return await productLocalRepository.getById(request.data);
    } else {
      return await productServerRepository.getProduct(storeId: request.storeId ?? '', productId: request.data);
    }
  }

  @override
  Future<ApiResult<Product>> update(BaseRepoRequest<Product> request) async {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_updateSuccess.tr(args: [request.data.name]));
      return await productLocalRepository.update(request);
    } else {
      final response = await productServerRepository.update(request);
      ToastNotificationService.show(title: LocaleKeys.notification_updateSuccess.tr(args: [request.data.name]));
      return response;
    }
  }

  Future<ApiResult<PaginationResponse<List<Product>>>> getAllByStoreAndBranchId(
    BaseRepoRequest<PaginationIndexRequest> request,
  ) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
      // return productLocalRepository.getAllByStoreAndBranchId(request.storeId);
    } else {
      return productServerRepository.getAllByStoreAndBranchId(request);
    }
  }

  Future<ApiResult<Product>> addProductQuantityToStock(AddProductQtyToStockrequest request) async {
    if (appMode == AppMode.local) {
      final product = await getById(request.overide(data: request.productId));

      final newQuantity = (product.response?.quantity ?? 0) + (request.data.quantity ?? 0);

      product.when(
        success: (response) async {
          final productUpdated = await update(request.overide(data: product.response!..quantity = newQuantity));

          final productHistory = await productHistoryRepository.create(
            request.overide(
              data: ProductHistory(
                productId: response.id,
                event: ProductHistoryEvent.addToStock.name,
                newData: {"priceCategory": request.data.priceSelected, "qty": request.data.quantity},
                info: BaseHiveData(createAt: DateTime.now(), updateAt: DateTime.now()),
              ),
            ),
          );

          // productHistory.when(
          //   success: (response) async {
          //     await transactionRepository.createTransaction(
          //       CreateTransactionRequest(
          //         storeId: request.storeId ?? '',
          //         userId: request.userId ?? '',
          //         method: TransactionMethodType.addProduct,
          //         totalPrice: request.amountCost,
          //         transactionType: TransactionType.expenses,
          //         valueId: response.id,
          //       ),
          //     );
          //   },
          // );

          return productUpdated;
        },
        failure: (error) {},
      );
    } else {
      throw UnimplementedError();
    }

    return ApiResult(error: 'addProductQuantityToStock error');
  }

  Future<void> orderCompletedUpdate(BaseRepoRequest<Cart> request) async {
    if (appMode == AppMode.local) {
      for (OrderItem item in request.data.cartItems) {
        if (item.product?.id != null) {
          // final product = await getById(storeId: cart!.storeId, productId: item.product!.id);
          final product = await getById(request.overide(data: item.product?.id));

          final newQuantity = (product.response?.quantity ?? 0) - (item.product?.quantity ?? 0);

          await productLocalRepository.update(request.overide(data: product.response!..quantity = newQuantity));
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

  Future<void> addQuantity({
    required String storeId,
    required productId,
    String? productTypeId,
    required num reduceQty,
  }) async {
    await productServerRepository.addQuantity(
      storeId: storeId,
      productId: productId,
      productTypeId: productTypeId,
      reduceQty: reduceQty,
    );
  }

  Future<ApiResult<List<ProductHistory>>> getProductHistory({
    required String productId,
    required String storeId,
    int? limit,
  }) async {
    return await productServerRepository.getProductHistory(productId: productId, storeId: storeId, limit: limit);
  }

  @override
  Future<ApiResult<List<Product>>> getAllByIds(List<String> ids) {
    throw throw UnimplementedError();
  }

  @override
  Future<ApiResult> deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Product>> updateProduct(BaseRepoRequest<UpdateProductImageRequest> request) async {
    final ApiResult<Product> result;
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      result = await productServerRepository.updateProduct(request);
      showToast(
        title: LocaleKeys.notification_updateSuccess.tr(args: [request.data.product?.name ?? 'Product']),
        type: ToastificationType.success,
      );
    }

    return result;
  }

  @override
  Future<ApiResult> deleteProduct(BaseRepoRequest<Product> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      final result = await productServerRepository.deleteProduct(request);
      ToastNotificationService.show(title: LocaleKeys.notification_deleteSuccess.tr(args: [tag]));
      log('Delete product ${request.data.id} success', name: runtimeType.toString());
      return result;
    }
  }

  @override
  Future<ApiResult<Product>> createProduct(BaseRepoRequest<CreateProductRequest> request) async {
    final ApiResult<Product> result;
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      result = await productServerRepository.createProduct(request);
    }
    showToast(
      title: LocaleKeys.notification_createSuccess.tr(args: [request.data.product.name]),
      type: ToastificationType.success,
    );
    return result;
  }
}
