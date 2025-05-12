// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:cloud_firestore/cloud_firestore.dart' show QuerySnapshot;
import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/constances/firebase/firebase_firestore_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/transaction.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_transaction_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/pagination_index_request.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/server/i_transaction_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/transaction_repository.dart';
import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';
import 'package:ez_shop_sync/src/services/firebase_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ITransactionServerRepository, env: [Flavor.DEV, Flavor.STG, Flavor.PROD])
class FirestoreTransactionServerRepository implements ITransactionServerRepository {
  final FirebaseService firebaseService;

  FirestoreTransactionServerRepository({required this.firebaseService});

  @override
  Future<ApiResult<Transaction>> create(BaseRepoRequest<CreateTransactionRequest> request) async {
    try {
      final now = DateTime.now();

      final transactionId = now.toTransactionFormatId(prefix: ApplicationConstance.transactionPrefix);
      final refStoreTransaction = firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_TRANSACTIONS)
          .doc(transactionId);

      final serverNow = fs.FieldValue.serverTimestamp();

      final payload = Transaction(
        id: transactionId,
        transactionType: request.data.transactionType.name,
        method: request.data.method.name,
        valueId: request.data.valueId,
        totalPrice: request.data.totalPrice,

        info: BaseHiveData(
          createAt: serverNow,
          updateAt: serverNow,
          createBy: request.userId,
          updateBy: request.userId,
          storeId: request.storeId,
          branchId: request.branchId,
        ),
      );

      await refStoreTransaction.set(payload.toJson());

      return Future.value(ApiResult(response: payload));
    } catch (e) {
      return Future.value(ApiResult(error: e));
    }
  }

  @override
  Future<ApiResult<List<Transaction>>> getByDateRange(BaseRepoRequest<DateRangeRequest> request) async {
    try {
      final snapshot =
          await firebaseService.storesCollection
              .doc(request.storeId)
              .collection(FirebaseFirestoreConstance.COLLECTION_TRANSACTIONS)
              .where('info.createAt', isGreaterThanOrEqualTo: fs.Timestamp.fromDate(request.data.start))
              .where('info.createAt', isLessThanOrEqualTo: fs.Timestamp.fromDate(request.data.end))
              .get();

      log('snapshot getRange transaction : ${snapshot.docs.map((e) => Transaction.fromJson(e.data())).toList()}');
      final response = snapshot.docs.map((e) => Transaction.fromJson(e.data())).toList();

      return ApiResult(response: response);
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  @override
  Future<ApiResult<TransactionStatementResponse>> getItemsByLimit(
    BaseRepoRequest<PaginationIndexRequest> request,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (request.data.lastDocument != null) {
        snapshot =
            await firebaseService.storesCollection
                .doc(request.storeId)
                .collection(FirebaseFirestoreConstance.COLLECTION_TRANSACTIONS)
                .orderBy('info.createAt', descending: true)
                .limit(request.data.limit)
                .startAfterDocument(request.data.lastDocument!)
                .get();
      } else {
        snapshot =
            await firebaseService.storesCollection
                .doc(request.storeId)
                .collection(FirebaseFirestoreConstance.COLLECTION_TRANSACTIONS)
                .orderBy('info.createAt', descending: true)
                .limit(request.data.limit)
                .get();
      }

      log('snapshot getRange : ${snapshot.docs.map((e) => Transaction.fromJson(e.data())).toList()}');
      final response = snapshot.docs.map((e) => Transaction.fromJson(e.data())).toList();
      return ApiResult(
        response: TransactionStatementResponse(transactions: response, lastDocument: snapshot.docs.last),
      );
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }
}
