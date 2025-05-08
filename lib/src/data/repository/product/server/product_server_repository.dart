import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/src/constances/firebase/firebase_firestore_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/product_history_event.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_history.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_history_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_request.dart';
import 'package:ez_shop_sync/src/data/repository/image/image_repository.dart';
import 'package:ez_shop_sync/src/data/repository/image/server/image_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/i_product_repository.dart';
import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';
import 'package:ez_shop_sync/src/services/firebase_service.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

@Singleton()
@Injectable()
class ProductServerRepository implements IProductRepository {
  final FirebaseService firebaseService;
  final ImageRepository imageRepository;
  ProductServerRepository({required this.firebaseService, required this.imageRepository});

  Future<ApiResult<Product>> create(BaseRepoRequest<Product> request) async {
    final productInfo = BaseHiveData(
      createAt: FieldValue.serverTimestamp(),
      updateAt: FieldValue.serverTimestamp(),
      createBy: request.data.ownerId,
      updateBy: request.data.ownerId,
    );
    request.data.info ??= productInfo;

    final createRef = await firebaseService.storesCollection
        .doc(request.storeId)
        .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
        .add(request.data.toJson());

    await updateHistory(
      CreateProductHistoryRequest(
        storeId: request.storeId,
        userId: request.data.ownerId,
        productId: createRef.id,
        data: ProductHistoryEvent.create,
        info: productInfo,
      ),
    );

    final updateProductId = await update(BaseRepoRequest.build(request, request.data..id = createRef.id));

    return ApiResult(response: updateProductId.response);
  }

  @override
  Future<ApiResult<Product>> createProduct(BaseRepoRequest<CreateProductRequest> request) async {
    if (request.data.image != null) {
      String fileName = '${const Uuid().v4()}_${basename(request.data.image!.path)}';

      final imageUrlResult = await imageRepository.uploadImageToStore(
        BaseRepoRequest.build(request, UploadImageRequest(file: request.data.image!, fileName: fileName)),
      );

      return await create(BaseRepoRequest.build(request, request.data.product..imageUrl = imageUrlResult));
    } else {
      return await create(BaseRepoRequest.build(request, request.data.product));
    }
  }

  Future<ApiResult<List<Product>?>> getAllByStoreId(String id) async {
    try {
      final products =
          await firebaseService.storesCollection
              .doc(id)
              .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
              .get();

      final response = products.docs.map((e) => Product.fromJson(e.data())).toList();

      log('getAllByStoreId : ${response.map((e) => e.id)}');
      if (products.docs.isEmpty) {
        return ApiResult(error: null, appErrorType: AppErrorType.somethingWentWrong);
      }

      return ApiResult(response: response);
    } catch (e) {
      return ApiResult(response: []);
    }
  }

  Future<ApiResult> delete(BaseRepoRequest<String> request) async {
    try {
      await firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
          .doc(request.data)
          .delete();

      return ApiResult(response: 'Delete ${request.data} success');
    } catch (e) {
      log(' delete $e');
      return ApiResult(error: e);
    }
  }

  Future<ApiResult<Product>> update(BaseRepoRequest<Product> request) async {
    try {
      log('update product id ${request.data.id}');
      final docRef = firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
          .doc(request.data.id);

      await docRef.update({...request.data.toJson(), 'updateAt': FieldValue.serverTimestamp()});

      return ApiResult(response: request.data);
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  Future<ApiResult<Product>> getProduct({required String storeId, required String productId}) async {
    try {
      final result =
          await firebaseService.storesCollection
              .doc(storeId)
              .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
              .doc(productId)
              .get();

      return ApiResult(response: Product.fromJson(result.data() ?? {}));
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  Future<ApiResult<List<Product>>> getAllByIds({required String storeId, required List<String> productIds}) async {
    try {
      final result =
          await firebaseService.storesCollection
              .doc(storeId)
              .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
              .where(FieldPath.documentId, whereIn: productIds)
              .get();

      final productResponse =
          result.docs.map((doc) {
            final dataCombineId = {...doc.data(), 'id': doc.id};
            return dataCombineId;
          }).toList();

      log('productResponse $productResponse');
      return ApiResult(response: productResponse.map((e) => Product.fromJson(e)).toList());
    } catch (e) {
      log('productResponse failure $e');
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  Future<void> updateHistory(CreateProductHistoryRequest request) async {
    request.info?.updateAt = FieldValue.serverTimestamp();

    await firebaseService.storesCollection
        .doc(request.storeId)
        .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
        .doc(request.productId)
        .collection(FirebaseFirestoreConstance.COLLECTION_ORDER_HISTORY)
        .add(request.toJson());
  }

  Future<void> reduceQuantity({
    required String storeId,
    required productId,
    String? productTypeId,
    required num reduceQty,
  }) async {
    try {
      final currentProductRef = firebaseService.storesCollection
          .doc(storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
          .doc(productId);

      final currentProduct = await currentProductRef.get();

      if (!currentProduct.exists) {
        log('Document does not exist');
        return;
      }

      var currentProductType = Product.fromJson(currentProduct.data() ?? {});

      final currentProductTypeQty = currentProductType.productTypeList?.firstWhere((e) => e.id == productTypeId);

      int? index = currentProductType.productTypeList?.indexWhere((item) => item.id == productTypeId);

      if (index == -1) {
        log('Item not found in the array');
        return;
      }

      if ((currentProductTypeQty?.quantity ?? 0) >= reduceQty) {
        final reducedQty = (currentProductTypeQty?.quantity ?? 0) - reduceQty;

        currentProductType.productTypeList![index!].quantity = reducedQty;
        await currentProductRef.update({
          'productTypeList': currentProductType.productTypeList?.map((e) => e.toJson()).toList(),
        });
      }
    } catch (e) {
      log('error reduceQuantity : $e');
    }
  }

  Future<ApiResult<List<ProductHistory>>> getProductHistory({
    required productId,
    required String storeId,
    int? limit,
  }) async {
    try {
      final result =
          await firebaseService.storesCollection
              .doc(storeId)
              .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
              .doc(productId)
              .collection(FirebaseFirestoreConstance.COLLECTION_ORDER_HISTORY)
              .orderBy('info.createAt', descending: true)
              .limit(limit ?? 10)
              .get();

      final productHistoryResponse = result.docs;

      return ApiResult(response: productHistoryResponse.map((e) => ProductHistory.fromJson(e.data())).toList());
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  @override
  Future<ApiResult<Product>> updateProduct(BaseRepoRequest<UpdateProductImageRequest> request) async {
    try {
      if (request.data.updatedImage != null && request.data.product?.imageUrl != null) {
        final ref = firebaseService.storage.refFromURL(request.data.imageRefUrl);

        final newUrl = await ref.getDownloadURL();
        await ref.putFile(request.data.updatedImage!);

        return await update(BaseRepoRequest.build(request, request.data.product!..imageUrl = newUrl));
      } else {
        return await update(BaseRepoRequest.build(request, request.data.product!));
      }
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  @override
  Future<ApiResult> deleteProduct(BaseRepoRequest<Product> request) async {
    await delete(BaseRepoRequest.build(request, request.data.id));
    await imageRepository.deleteImageFromStore(BaseRepoRequest.build(request, request.data.imageUrl!));

    return ApiResult(response: 'deleteProduct ${request.data.id} success');
  }
}
