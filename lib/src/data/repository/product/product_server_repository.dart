import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/src/constances/firebase/firebase_firestore_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';
import 'package:ez_shop_sync/src/services/firebase_service.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class ProductServerRepository {
  final FirebaseService firebaseService;

  ProductServerRepository({
    required this.firebaseService,
  });

  Future<ApiResult<Product?>> create(Product request) async {
    request.info?.createBy = FieldValue.serverTimestamp();

    final productCreated = await firebaseService.storesCollection
        .doc(request.storeId)
        .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
        .add(request.toJson());

    final response = await productCreated.get();

    if (response.data() == null) {
      return ApiResult(
          error: null, appErrorType: AppErrorType.somethingWentWrong);
    }

    return ApiResult(response: request..id = response.id);
  }

  Future<ApiResult<List<Product>?>> getAllByStoreId(String id) async {
    try {
      final products = await firebaseService.storesCollection
          .doc(id)
          .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
          .get();

      final response = products.docs
          .map((e) => Product.fromJson(e.data())..id = e.id)
          .toList();

      if (products.docs.isEmpty) {
        return ApiResult(
            error: null, appErrorType: AppErrorType.somethingWentWrong);
      }

      return ApiResult(response: response);
    } catch (e) {
      return ApiResult(response: []);
    }
  }

  Future<void> delete({
    required String storeId,
    required String productId,
  }) async {
    return await firebaseService.storesCollection
        .doc(storeId)
        .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
        .doc(productId)
        .delete();
  }

  Future<ApiResult<Product>> update(Product updated,
      {required String storeId, required String productId}) async {
    try {
      await firebaseService.storesCollection
          .doc(storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
          .doc(productId)
          .set(updated.toJson());

      return ApiResult(response: updated);
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  Future<ApiResult<Product>> getProduct(
      {required String storeId, required String productId}) async {
    try {
      final result = await firebaseService.storesCollection
          .doc(storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
          .doc(productId)
          .get();

      return ApiResult(response: Product.fromJson(result.data() ?? {}));
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  Future<ApiResult<List<Product>>> getAllByIds(
      {required String storeId, required List<String> productIds}) async {
    try {
      final result = await firebaseService.storesCollection
          .doc(storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
          .where(FieldPath.documentId, whereIn: productIds)
          .get();

      final productResponse = result.docs.map((doc) {
        final dataCombineId = {
          ...doc.data(),
          'id': doc.id,
        };
        return dataCombineId;
      }).toList();

      log('productResponse $productResponse');
      return ApiResult(
          response: productResponse.map((e) => Product.fromJson(e)).toList());
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }
}
