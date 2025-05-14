// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_order_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/pagination_index_request.dart';
import 'package:ez_shop_sync/src/data/dto/response/order_history_reponse.dart';
import 'package:ez_shop_sync/src/data/repository/cart/cart_repository.dart';
import 'package:ez_shop_sync/src/data/repository/i_repository.dart';
import 'package:ez_shop_sync/src/data/repository/order/i_order_repository.dart';
import 'package:ez_shop_sync/src/data/repository/order/local/i_order_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/order/server/order_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/transaction_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class OrderRepository extends IRepository<ProductOrder> implements IOrderRepository {
  IOrderLocalRepository orderLocalRepository;
  IOrderServerRepository orderServerRepository;

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
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      throw UnimplementedError();
    }
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
  deleteAllByIds(List<String> ids) {
    if (appMode == AppMode.local) {
      ToastNotificationService.show(title: LocaleKeys.notification_deleteSuccess.tr());
      return orderLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<ProductOrder>>> getAll() async {
    if (appMode == AppMode.local) {
      return await orderLocalRepository.getAll();
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult<OrderHistoryResponse>> getAllRange(BaseRepoRequest<PaginationIndexRequest> request) async {
    if (appMode == AppMode.local) {
      return Future.value(
        ApiResult(
          response: OrderHistoryResponse(
            orders: orderLocalRepository.getAllRange(request.data.start, request.data.limit),
          ),
        ),
      );
    } else {
      return await orderServerRepository.getOrderHistoryList(request);
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

  Future<ApiResult<List<ProductOrder>>> getAllBetween(BaseRepoRequest<OrderGetByDateRangeRequest> request) async {
    if (appMode == AppMode.local) {
      final resultAllBetween = orderLocalRepository.getAllRange(
        request.data.start.millisecondsSinceEpoch,
        request.data.end.millisecondsSinceEpoch,
      );
      return Future.value(ApiResult(response: resultAllBetween));
    } else {
      return await orderServerRepository.getByDatetime(request);
    }
  }

  Future<ApiResult<ProductOrder>> getOrderHistoryDetail(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      throw UnimplementedError();
    } else {
      return await orderServerRepository.getOrderHistory(request);
    }
  }

  @override
  Future<ApiResult<List<ProductOrder>>> getAllByIds(List<String> ids) {
    if (appMode == AppMode.local) {
      return orderLocalRepository.getAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<ProductOrder>> createFromCart(BaseRepoRequest<CreateOrderRequest> request) async {
    if (appMode == AppMode.local) {
      return await create(
        request.overide(
          data: ProductOrder(
            status: request.data.status.name,
            orderItems: request.data.orderItems,
            paymentType: request.data.paymentType.name,
          ),
        ),
      );
    } else {
      return await orderServerRepository.createOrder(request);
    }
  }
}

class OrderGetByDateRangeRequest {
  final DateTime start;
  final DateTime end;
  OrderGetByDateRangeRequest({required this.start, required this.end});
}
