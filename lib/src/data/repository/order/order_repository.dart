// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/constances/date_format_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/order_status_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_method_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart'
    as orderType;
import 'package:ez_shop_sync/src/data/dto/hive_object/transaction.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_order_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_transaction_request.dart';
import 'package:ez_shop_sync/src/data/dto/response/create_order_response.dart';
import 'package:ez_shop_sync/src/data/repository/cart/cart_repository.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/transaction_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/list_order_item_extension.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

abstract class IOrderRepository {
  List<orderType.ProductOrder> getAll({AppMode appMode = AppMode.local});
  orderType.ProductOrder? getById(String id, {AppMode appMode = AppMode.local});
  Future<ApiResult<orderType.ProductOrder>> create(CreateOrderRequest request);
  Future<orderType.ProductOrder> update(
      String id, orderType.ProductOrder updated,
      {AppMode appMode = AppMode.local});
  Future<void> delete(String id, {AppMode appMode = AppMode.local});
  Future<void> deleteAll(List<String> ids, {AppMode appMode = AppMode.local});
}

@Singleton()
@Injectable()
class OrderRepository implements IOrderRepository {
  OrderLocalRepository orderLocalRepository;
  OrderServerRepository orderServerRepository;
  CartRepository cartRepository;
  TransactionRepository transactionRepository;

  OrderRepository({
    required this.orderLocalRepository,
    required this.orderServerRepository,
    required this.cartRepository,
    required this.transactionRepository,
  });

  @override
  Future<ApiResult<orderType.ProductOrder>> create(CreateOrderRequest request,
      {AppMode appMode = AppMode.local}) async {
    final now = DateTime.now();
    if (appMode == AppMode.local) {
      String fullUuid = const Uuid().v4();
      String shortUuid = fullUuid.replaceAll('-', '').substring(0, 4);
      String prefixedUuid =
          '${now.format(DateFormatConstance.YYYYMMDD_HHMMMSS).toUpperCase()}$shortUuid';

      final orderCreate = orderType.ProductOrder(
        storeId: request.storeId,
        id: prefixedUuid,
        status: OrderStatusType.complete.name,
        orderItems: request.orderItems,
        paymentType: request.paymentType.name,
        userId: request.userId,
      );

      final result = await orderLocalRepository.create(
        orderCreate,
        userId: request.userId,
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

      return ApiResult();
    } else {
      return await orderServerRepository.createOrder(request);
    }
  }

  @override
  delete(String id, {AppMode? appMode = AppMode.local, String? name}) {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(
          title: LocaleKeys.notification_deleteSuccess.tr(args: [name ?? '']));
      return orderLocalRepository.delete(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  deleteAll(List<String> ids, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(
          title: LocaleKeys.notification_deleteSuccess.tr());
      return orderLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  List<orderType.ProductOrder> getAll({AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return orderLocalRepository.getAll();
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
          ApiResult(
            response: OrderHistoryResponse(
              orders: orderLocalRepository.getAllRange(start, end),
            ),
          ),
        );
      } else {
        return await orderServerRepository.getOrderHistoryList(
            storeId: storeId, limit: limit, lastDocument: lastDocument);
      }
    } catch (e) {
      return Future.value(ApiResult());
    }
  }

  @override
  orderType.ProductOrder? getById(String id,
      {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return orderLocalRepository.getById(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<orderType.ProductOrder> update(
      String id, orderType.ProductOrder updated,
      {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return orderLocalRepository.update(id, updated);
    } else {
      throw UnimplementedError();
    }
  }

  List<orderType.ProductOrder> getAllBetween(
    String storeId, {
    required DateTime start,
    required DateTime end,
    AppMode? appMode = AppMode.local,
  }) {
    if (appMode == AppMode.local) {
      return orderLocalRepository
          .getAllBetween(start: start, end: end)
          .where((e) => e.storeId == storeId)
          .toList();
    } else {
      throw UnimplementedError();
    }
  }
}

class OrderHistoryResponse {
  final List<orderType.ProductOrder> orders;
  final QueryDocumentSnapshot? lastDocument;

  OrderHistoryResponse({
    required this.orders,
    this.lastDocument,
  });
}
