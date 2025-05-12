import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/constances/firebase/firebase_firestore_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/product_history_event.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_method_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_order_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_history_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_transaction_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/pagination_index_request.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:ez_shop_sync/src/data/dto/response/order_history_reponse.dart';
import 'package:ez_shop_sync/src/data/repository/order/server/order_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/transaction_repository.dart';
import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';
import 'package:ez_shop_sync/src/services/firebase_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/list_order_item_extension.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IOrderServerRepository, env: [Flavor.DEV, Flavor.STG, Flavor.PROD])
class FirestoreOrderServerRepository implements IOrderServerRepository {
  final FirebaseService firebaseService;
  final ProductRepository productRepository;
  final TransactionRepository transactionRepository;

  FirestoreOrderServerRepository({
    required this.firebaseService,
    required this.productRepository,
    required this.transactionRepository,
  });

  @override
  Future<ApiResult<ProductOrder>> createOrder(BaseRepoRequest<CreateOrderRequest> request) async {
    try {
      final now = DateTime.now();

      final orderId = now.toTransactionFormatId(prefix: ApplicationConstance.orderPrefix);

      final info = BaseHiveData(
        createAt: FieldValue.serverTimestamp(),
        updateAt: FieldValue.serverTimestamp(),
        createBy: request.userId,
        updateBy: request.userId,
        branchId: request.branchId,
        storeId: request.storeId,
      );

      final payload = ProductOrder(
        id: orderId,
        status: request.data.status.name,
        orderItems: request.data.orderItems,
        paymentType: request.data.paymentType.name,
        info: info,
        receiveAmount: request.data.receiveAmount,
        changeAmount: request.data.changeAmount,
        serviceCharge: request.data.serviceCharge,
      );

      final refOrderCreated = firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_ORDERS)
          .doc(orderId);

      await refOrderCreated.set(payload.toJson());

      final orderCreated = await refOrderCreated.get();

      for (var orderItem in request.data.orderItems) {
        await productRepository.reduceQuantity(
          storeId: request.storeId ?? '',
          productId: orderItem.product?.id ?? '',
          productTypeId: orderItem.product?.priceSelected,
          reduceQty: orderItem.product?.quantity ?? 0,
        );

        await productRepository.updateHistory(
          CreateProductHistoryRequest(
            storeId: request.storeId,
            userId: request.userId,
            productId: orderItem.product!.id,
            productTypeId: orderItem.product?.priceSelected,
            data: ProductHistoryEvent.order,
            refId: orderId,
            info: info,
            branchId: request.branchId,
          ),
        );
      }

      await transactionRepository.createTransaction(
        BaseRepoRequest.build(
          request,
          CreateTransactionRequest(
            method: TransactionMethodType.order,
            totalPrice: request.data.cart.cartItems.totalPrice,
            transactionType: TransactionType.income,
            valueId: orderId,
          ),
        ),
      );

      final productOrder = ProductOrder.fromJson(orderCreated.data()!);

      log('infoResponse.createAtDateTime 1 ${productOrder.info?.createAt}');
      return ApiResult(response: productOrder);
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  @override
  Future<ApiResult<OrderHistoryResponse>> getOrderHistoryList(BaseRepoRequest<PaginationIndexRequest> request) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot;

      log('request ${request.storeId} ${request.userId}');
      log('request ${request.data}');
      if (request.data.lastDocument != null) {
        snapshot =
            await firebaseService.storesCollection
                .doc(request.storeId)
                .collection(FirebaseFirestoreConstance.COLLECTION_ORDERS)
                .orderBy('info.createAt', descending: true)
                .limit(request.data.limit)
                .startAfterDocument(request.data.lastDocument!)
                .get();
      } else {
        snapshot =
            await firebaseService.storesCollection
                .doc(request.storeId)
                .collection(FirebaseFirestoreConstance.COLLECTION_ORDERS)
                .orderBy('info.createAt', descending: true)
                .limit(request.data.limit)
                .get();
      }

      log('snapshot getRange : ${snapshot.docs.map((e) => ProductOrder.fromJson(e.data())).toList()}');
      final response = snapshot.docs.map((e) => ProductOrder.fromJson(e.data())).toList();
      return ApiResult(response: OrderHistoryResponse(orders: response, lastDocument: snapshot.docs.last));
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  @override
  Future<ApiResult<ProductOrder>> getOrderHistory(BaseRepoRequest<String> request) async {
    try {
      final result =
          await firebaseService.storesCollection
              .doc(request.storeId)
              .collection(FirebaseFirestoreConstance.COLLECTION_ORDERS)
              .doc(request.data)
              .get();

      final resultData = result.data() ?? {};
      final productOrder = ProductOrder.fromJson(resultData)..id = result.id;
      return ApiResult(response: productOrder);
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  @override
  Future<ApiResult<List<ProductOrder>>> getByDatetime(BaseRepoRequest<OrderGetByDateRangeRequest> request) async {
    try {
      final snapshot =
          await firebaseService.storesCollection
              .doc(request.storeId)
              .collection(FirebaseFirestoreConstance.COLLECTION_ORDERS)
              .where('info.createAt', isGreaterThanOrEqualTo: Timestamp.fromDate(request.data.start))
              .where('info.createAt', isLessThanOrEqualTo: Timestamp.fromDate(request.data.end))
              .get();

      log('snapshot getRange : ${snapshot.docs.map((e) => ProductOrder.fromJson(e.data())).toList()}');
      final response = snapshot.docs.map((e) => ProductOrder.fromJson(e.data())).toList();

      return ApiResult(response: response);
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }
}
