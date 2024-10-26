import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/constances/date_format_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/order_status_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart' as orderType;
import 'package:ez_shop_sync/src/data/dto/request/create_order_request.dart';
import 'package:ez_shop_sync/src/data/repository/cart/cart_repository.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

abstract class IOrderRepository {
  List<orderType.ProductOrder> getAll({AppMode appMode = AppMode.local});
  orderType.ProductOrder? getById(String id, {AppMode appMode = AppMode.local});
  Future<orderType.ProductOrder> create(CreateOrderRequest request);
  Future<orderType.ProductOrder> update(String id, orderType.ProductOrder updated, {AppMode appMode = AppMode.local});
  Future<void> delete(String id, {AppMode appMode = AppMode.local});
  Future<void> deleteAll(List<String> ids, {AppMode appMode = AppMode.local});
}

@Singleton()
@Injectable()
class OrderRepository implements IOrderRepository {
  OrderLocalRepository orderLocalRepository;
  OrderServerRepository orderServerRepository;
  CartRepository cartRepository;

  OrderRepository({
    required this.orderLocalRepository,
    required this.orderServerRepository,
    required this.cartRepository,
  });

  @override
  Future<orderType.ProductOrder> create(CreateOrderRequest request) async {
    final now = DateTime.now();
    if (request.appMode == AppMode.local) {
      String fullUuid = const Uuid().v4();
      String shortUuid = fullUuid.replaceAll('-', '').substring(0, 4);
      String prefixedUuid = '${request.storeCode}${now.format(DateFormatConstance.YYYYMMDD_HHMMSS)}$shortUuid';

      final orderCreate = orderType.ProductOrder(
        id: prefixedUuid,
        status: OrderStatusType.complete.name,
        cartItems: request.cart.cartItems,
        paymentType: request.paymentType.name,
      );

      final result = await orderLocalRepository.create(orderCreate);

      return result;
    } else {
      throw UnimplementedError();
    }
  }

  @override
  delete(String id, {AppMode? appMode = AppMode.local, String? name}) {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_deleteSuccess.tr(args: [name ?? '']));
      return orderLocalRepository.delete(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  deleteAll(List<String> ids, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_deleteSuccess.tr());
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

  List<orderType.ProductOrder> getAllRange(int start, int end, {AppMode? appMode = AppMode.local}) {
    try {
      if (appMode == AppMode.local) {
        return orderLocalRepository.getAllRange(start, end);
      } else {
        throw UnimplementedError();
      }
    } catch (e) {
      return [];
    }
  }

  @override
  orderType.ProductOrder? getById(String id, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return orderLocalRepository.getById(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<orderType.ProductOrder> update(String id, orderType.ProductOrder updated, {AppMode? appMode = AppMode.local}) {
    if (appMode == AppMode.local) {
      return orderLocalRepository.update(id, updated);
    } else {
      throw UnimplementedError();
    }
  }
}
