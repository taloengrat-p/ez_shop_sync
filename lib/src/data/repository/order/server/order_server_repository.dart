import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/src/constances/date_format_constance.dart';
import 'package:ez_shop_sync/src/constances/firebase/firebase_firestore_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/product_history_event.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_history_request.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';
import 'package:ez_shop_sync/src/services/firebase_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@Singleton()
@Injectable()
class OrderServerRepository {
  final FirebaseService firebaseService;
  final ProductRepository productRepository;

  OrderServerRepository({required this.firebaseService, required this.productRepository});

  Future<ApiResult<ProductOrder>> createOrder(BaseRepoRequest<ProductOrder> request) async {
    try {
      final now = DateTime.now();
      String fullUuid = const Uuid().v4();
      String shortUuid = fullUuid.replaceAll('-', '').substring(0, 6);
      String orderId = '${now.format(DateFormatConstance.YYYYMMDD_HHMMMSS).toUpperCase()}$shortUuid';

      final createAt = FieldValue.serverTimestamp();
      final info = BaseHiveData(
        createAt: createAt,
        updateAt: createAt,
        createBy: request.userId,
        updateBy: request.userId,
      );
      request.data.info = info;

      final refOrderCreated = firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_ORDERS)
          .doc(orderId);

      await refOrderCreated.set(request.data.toJson());

      final orderCreated = await refOrderCreated.get();

      final infoResponse = BaseHiveData.fromJson(orderCreated.data()?['info']);
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
            orderId: orderId,
            info: infoResponse,
          ),
        );
      }

      return ApiResult(
        response: ProductOrder(
          id: orderId,
          storeId: request.storeId ?? '',
          status: request.data.status,
          orderItems: request.data.orderItems,
          paymentType: request.data.paymentType,
          userId: request.userId ?? '',
          receiveAmount: request.data.receiveAmount,
          info: infoResponse,
        ),
      );
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  Future<ApiResult<OrderHistoryResponse>> getOrderHistoryList({
    required String storeId,
    required int limit,
    QueryDocumentSnapshot? lastDocument,
  }) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (lastDocument != null) {
        snapshot =
            await firebaseService.storesCollection
                .doc(storeId)
                .collection(FirebaseFirestoreConstance.COLLECTION_ORDERS)
                .orderBy('info.createAt', descending: true)
                .limit(limit)
                .startAfterDocument(lastDocument)
                .get();
      } else {
        snapshot =
            await firebaseService.storesCollection
                .doc(storeId)
                .collection(FirebaseFirestoreConstance.COLLECTION_ORDERS)
                .orderBy('info.createAt', descending: true)
                .limit(limit)
                .get();
      }

      final response = snapshot.docs.map((e) => ProductOrder.fromJson(e.data())..id = e.id).toList();
      return ApiResult(response: OrderHistoryResponse(orders: response, lastDocument: snapshot.docs.last));
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  Future<ApiResult<ProductOrder>> getOrderHistory(String storeId, String id) async {
    try {
      final result =
          await firebaseService.storesCollection
              .doc(storeId)
              .collection(FirebaseFirestoreConstance.COLLECTION_ORDERS)
              .doc(id)
              .get();

      final resultData = result.data() ?? {};
      final productOrder = ProductOrder.fromJson(resultData)..id = result.id;
      return ApiResult(response: productOrder);
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }
}
