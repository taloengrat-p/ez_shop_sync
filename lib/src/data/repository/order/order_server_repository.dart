import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/src/constances/date_format_constance.dart';
import 'package:ez_shop_sync/src/constances/firebase/firebase_firestore_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_order_request.dart';
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

  OrderServerRepository({
    required this.firebaseService,
    required this.productRepository,
  });
  Future<ApiResult<ProductOrder>> createOrder(
      CreateOrderRequest request) async {
    try {
      final now = DateTime.now();
      String fullUuid = const Uuid().v4();
      String shortUuid = fullUuid.replaceAll('-', '').substring(0, 4);
      String orderId =
          '${now.format(DateFormatConstance.YYYYMMDD_HHMMSS)}$shortUuid';

      final createAt = FieldValue.serverTimestamp();
      request.createAt = createAt;
      await firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_ORDERS)
          .doc(orderId)
          .set(request.toJson());

      return ApiResult(
        response: ProductOrder(
          id: orderId,
          storeId: request.storeId,
          status: request.status.name,
          orderItems: request.orderItems,
          paymentType: request.paymentType.name,
          userId: request.userId,
        ),
      );
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  Future<ApiResult<List<ProductOrder>>> getOrderHistoryList({
    required String storeId,
    required int limit,
    QueryDocumentSnapshot? lastDocument,
  }) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (lastDocument != null) {
        snapshot = await firebaseService.storesCollection
            .doc(storeId)
            .collection(FirebaseFirestoreConstance.COLLECTION_ORDERS)
            .orderBy('createAt', descending: true)
            .limit(limit)
            .startAfterDocument(lastDocument)
            .get();
      } else {
        snapshot = await firebaseService.storesCollection
            .doc(storeId)
            .collection(FirebaseFirestoreConstance.COLLECTION_ORDERS)
            .orderBy('createAt', descending: true)
            .limit(limit)
            .get();
      }

      final response = snapshot.docs
          .map((e) => ProductOrder.fromJson(e.data())..id = e.id)
          .toList();
      return ApiResult(
        response: response,
      );
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }
}
