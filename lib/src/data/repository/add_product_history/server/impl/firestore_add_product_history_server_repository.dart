// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/constances/firebase/firebase_firestore_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/product_history_event.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_method_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_history_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_transaction_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/pagination_index_request.dart';
import 'package:ez_shop_sync/src/data/dto/response/add_product_history_response.dart';
import 'package:ez_shop_sync/src/data/repository/add_product_history/server/add_product_history_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/transaction_repository.dart';
import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';
import 'package:ez_shop_sync/src/services/firebase_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IAddProductHistoryServerRepository, env: [Flavor.DEV])
class AddProductHistoryServerRepository implements IAddProductHistoryServerRepository {
  final FirebaseService firebaseService;
  final TransactionRepository transactionRepository;
  final ProductRepository productRepository;
  AddProductHistoryServerRepository({
    required this.firebaseService,
    required this.transactionRepository,
    required this.productRepository,
  });

  @override
  Future<ApiResult<AddProduct>> createAddProductHistory(BaseRepoRequest<AddProduct> request) async {
    try {
      final addProductId = DateTime.now().toTransactionFormatId(prefix: ApplicationConstance.productImportPrefix);
      final addProductInfo = BaseHiveData(
        storeId: request.storeId,
        branchId: request.branchId,
        createAt: FieldValue.serverTimestamp(),
        updateAt: FieldValue.serverTimestamp(),
        createBy: request.userId,
        updateBy: request.userId,
      );

      request.data.info ??= addProductInfo;

      final refAddProductCreated = firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_ADD_PRODUCT_HISTORY)
          .doc(addProductId);

      final payload = request.data.copyWith(id: addProductId);

      await refAddProductCreated.set(payload.toJson());

      final orderCreated = await refAddProductCreated.get();

      for (var orderItem in request.data.addProductItems) {
        await productRepository.addQuantity(
          storeId: request.storeId,
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
            data: ProductHistoryEvent.addToStock,
            refId: addProductId,
            info: addProductInfo,
            branchId: request.branchId,
          ),
        );
      }

      await transactionRepository.createTransaction(
        BaseRepoRequest.build(
          request,
          CreateTransactionRequest(
            method: TransactionMethodType.addProduct,
            totalPrice: request.data.amountCost,
            transactionType: TransactionType.expenses,
            valueId: addProductId,
          ),
        ),
      );

      final infoResponse = BaseHiveData.fromJson(orderCreated.data()?['info']);

      return ApiResult(response: payload..info = infoResponse);
    } catch (e) {
      return ApiResult(error: e);
    }
  }

  @override
  Future<ApiResult<AddProductHistoryResponse>> getItemsByLimit(BaseRepoRequest<PaginationIndexRequest> request) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (request.data.lastDocument != null) {
        snapshot =
            await firebaseService.storesCollection
                .doc(request.storeId)
                .collection(FirebaseFirestoreConstance.COLLECTION_ADD_PRODUCT_HISTORY)
                .orderBy('info.createAt', descending: true)
                .limit(request.data.limit)
                .startAfterDocument(request.data.lastDocument!)
                .get();
      } else {
        snapshot =
            await firebaseService.storesCollection
                .doc(request.storeId)
                .collection(FirebaseFirestoreConstance.COLLECTION_ADD_PRODUCT_HISTORY)
                .orderBy('info.createAt', descending: true)
                .limit(request.data.limit)
                .get();
      }

      log('snapshot getRange : ${snapshot.docs.map((e) => AddProduct.fromJson(e.data())).toList()}');
      final response = snapshot.docs.map((e) => AddProduct.fromJson(e.data())).toList();
      return ApiResult(response: AddProductHistoryResponse(orders: response, lastDocument: snapshot.docs.last));
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  @override
  Future<ApiResult<AddProduct>> getDetailById(BaseRepoRequest<String> request) async {
    try {
      final refDoc = firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_ADD_PRODUCT_HISTORY)
          .doc(request.data);

      final value = await refDoc.get();

      return ApiResult(response: AddProduct.fromJson(value.data() ?? {}));
    } catch (e) {
      return ApiResult(error: '');
    }
  }
}
