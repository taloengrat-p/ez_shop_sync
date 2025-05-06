// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/constances/date_format_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/order_status_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_order_request.dart';
import 'package:ez_shop_sync/src/data/repository/cart/cart_repository.dart';
import 'package:ez_shop_sync/src/data/repository/i_repository.dart';
import 'package:ez_shop_sync/src/data/repository/order/local/order_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/order/server/order_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/transaction_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

abstract class IOrderRepository {
  List<ProductOrder> getAll({AppMode appMode = AppMode.local});
  ProductOrder? getById(String id, {AppMode appMode = AppMode.local});
  Future<ApiResult<ProductOrder>> create(CreateOrderRequest request);
  Future<ProductOrder> update(String id, ProductOrder updated, {AppMode appMode = AppMode.local});
  Future<void> delete(String id, {AppMode appMode = AppMode.local});
  Future<void> deleteAll(List<String> ids, {AppMode appMode = AppMode.local});
}

@Singleton()
@Injectable()
class OrderRepository extends IRepository<ProductOrder> {
  OrderLocalRepository orderLocalRepository;
  OrderServerRepository orderServerRepository;
  CartRepository cartRepository;
  TransactionRepository transactionRepository;

  OrderRepository({
    required this.orderLocalRepository,
    required this.orderServerRepository,
    required this.cartRepository,
    required this.transactionRepository,
    required super.navigationService,
  }) : super(AppMode.server);

  @override
  Future<ApiResult<ProductOrder>> create(BaseRepoRequest<ProductOrder> request) async {
    final now = DateTime.now();
    if (appMode == AppMode.local) {
      String fullUuid = const Uuid().v4();
      String shortUuid = fullUuid.replaceAll('-', '').substring(0, 4);
      String prefixedUuid = '${now.format(DateFormatConstance.YYYYMMDD_HHMMMSS).toUpperCase()}$shortUuid';

      final orderCreate = ProductOrder(
        storeId: request.storeId ?? '',
        id: prefixedUuid,
        status: OrderStatusType.complete.name,
        orderItems: request.data.orderItems,
        paymentType: request.data.paymentType,
        userId: request.userId ?? '',
      );

      final result = await orderLocalRepository.create(
        BaseRepoRequest(storeId: request.storeId, userId: orderCreate.userId, data: orderCreate),
      );

      result.when(
        success: (response) {
          return ApiResult(response: response);
        },
        failure: (error) {
          return ApiResult(error: error);
        },
      );

      // await transactionRepository.create(
      //   CreateTransactionRequest(
      //     storeId: request.storeId,
      //     userId: request.userId,
      //     method: TransactionMethodType.order,
      //     totalPrice: request.cart.cartItems.totalPrice,
      //     transactionType: TransactionType.income,
      //     valueId: prefixedUuid,
      //   ),
      // );
      // return ApiResult(response:  );
    } else {
      return await orderServerRepository.createOrder(request);
    }

    return Future.value(ApiResult<ProductOrder>(error: 'create'));
  }

  @override
  Future<ApiResult> delete(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_deleteSuccess.tr(args: ['Order']));
      return orderLocalRepository.delete(request.data);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  deleteAllByIds(List<String> ids, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_deleteSuccess.tr());
      return orderLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<ProductOrder>>> getAll({AppMode? appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      return await orderLocalRepository.getAll();
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult<OrderHistoryResponse>> getAllRange(
    int start,
    int end, {
    AppMode? appMode = AppMode.local,
    required String storeId,
    required int limit,
    QueryDocumentSnapshot? lastDocument,
  }) async {
    try {
      if (appMode == AppMode.local) {
        return Future.value(
          ApiResult(response: OrderHistoryResponse(orders: orderLocalRepository.getAllRange(start, end))),
        );
      } else {
        return await orderServerRepository.getOrderHistoryList(
          storeId: storeId,
          limit: limit,
          lastDocument: lastDocument,
        );
      }
    } catch (e) {
      return Future.value(ApiResult());
    }
  }

  @override
  Future<ApiResult<ProductOrder>> getById(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      return await orderLocalRepository.getById(request.data);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<ProductOrder>> update(BaseRepoRequest<ProductOrder> request) async {
    if (appMode == AppMode.local) {
      return await orderLocalRepository.update(request);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult<List<ProductOrder>>> getAllBetween(
    String storeId, {
    required DateTime start,
    required DateTime end,
    AppMode? appMode = AppMode.local,
  }) async {
    if (appMode == AppMode.local) {
      final resultAllBetween = await orderLocalRepository.getAllBetween(start: start, end: end);

      resultAllBetween.when(
        success: (response) {
          return ApiResult(response: response.where((e) => e.storeId == storeId).toList());
        },
        failure: (error) {
          return ApiResult(error: error);
        },
      );
    } else {
      throw UnimplementedError();
    }
    return ApiResult(error: 'getAllBetween failure');
  }

  Future<ApiResult<ProductOrder>> getOrderHistoryDetail(String storeId, String id) async {
    return await orderServerRepository.getOrderHistory(storeId, id);
  }

  @override
  Future<ApiResult<List<ProductOrder>>> getAllByIds(List<String> ids) {
    if (appMode == AppMode.local) {
      return orderLocalRepository.getAllById(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  Future<ApiResult> createFromCart(BaseRepoRequest<CreateOrderRequest> request) async {
    if (appMode == AppMode.local) {
      return create(
        BaseRepoRequest(
          storeId: request.storeId,
          userId: request.userId,
          data: ProductOrder(
            storeId: request.storeId ?? '',
            userId: request.userId ?? '',
            status: request.data.status.name,
            orderItems: request.data.orderItems,
            paymentType: request.data.paymentType.name,
          ),
        ),
      );
    } else {
      throw UnimplementedError();
    }
  }
}

class OrderHistoryResponse {
  final List<ProductOrder> orders;
  final QueryDocumentSnapshot? lastDocument;

  OrderHistoryResponse({required this.orders, this.lastDocument});
}
