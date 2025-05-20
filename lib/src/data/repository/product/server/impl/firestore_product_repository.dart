// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/src/data/dto/request/product_request/get_product_request.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/constances/firebase/firebase_firestore_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/product_history_event.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_history.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_history_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/image_request/upload_image_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/pagination_index_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/product_request/update_product_image_request.dart';
import 'package:ez_shop_sync/src/data/dto/response/pagination_response.dart';
import 'package:ez_shop_sync/src/data/repository/image/image_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/server/i_product_server_repository.dart';
import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';
import 'package:ez_shop_sync/src/services/firebase_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/utils/image_picker_utils.dart';

@Injectable(as: IProductServerRepository, env: [Flavor.DEV, Flavor.STG, Flavor.PROD])
class FirestoreProductServerRepository implements IProductServerRepository {
  final FirebaseService firebaseService;
  final ImageRepository imageRepository;
  FirestoreProductServerRepository({required this.firebaseService, required this.imageRepository});

  Future<ApiResult<Product>> create(BaseRepoRequest<Product> request) async {
    final now = DateTime.now();

    final productId = now.toTransactionFormatId(prefix: ApplicationConstance.productPrefix);
    final productInfo = BaseHiveData(
      createAt: FieldValue.serverTimestamp(),
      updateAt: FieldValue.serverTimestamp(),
      createBy: request.data.ownerId,
      updateBy: request.data.ownerId,
      storeId: request.storeId,
      branchId: request.branchId,
    );
    request.data.info ??= productInfo;

    final payload = request.data..id = productId;
    await firebaseService.storesCollection
        .doc(request.storeId)
        .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
        .doc(productId)
        .set(payload.toJson());

    await updateHistory(
      CreateProductHistoryRequest(
        storeId: request.storeId,
        userId: request.data.ownerId,
        productId: productId,
        data: ProductHistoryEvent.create,
        info: productInfo,
        branchId: request.branchId,
      ),
    );

    return ApiResult(response: request.data);
  }

  Future<ProductProfileImage> createProductProfileImage(BaseRepoRequest<File> request) async {
    String fileName = '${const Uuid().v4()}_${basename(request.data.path)}';

    final imageUrlResult = await imageRepository.uploadImageToStore(
      BaseRepoRequest.build(request, UploadImageRequest(file: request.data, fileName: fileName)),
    );

    final imageThumbnail = await ImagePickerUtils.compressImageForThumbnail(request.data);

    throwIf(imageThumbnail == null, 'createProduct() imageThumbnail == null');

    String thumbnailfileName = 'thumbnail-${const Uuid().v4()}_${basename(imageThumbnail!.path)}';
    final imageThumbnailResult = await imageRepository.uploadImageToStore(
      BaseRepoRequest.build(request, UploadImageRequest(file: imageThumbnail, fileName: thumbnailfileName)),
    );

    return ProductProfileImage(thumbnail: imageThumbnailResult, profile: imageUrlResult);
  }

  @override
  Future<ApiResult<Product>> createProduct(BaseRepoRequest<CreateProductRequest> request) async {
    if (request.data.image != null) {
      final resultImageUpload = await createProductProfileImage(request.overide(data: request.data.image!));
      return await create(
        BaseRepoRequest.build(
          request,
          request.data.product
            ..imageUrl = resultImageUpload.profile
            ..imageThumbnail = resultImageUpload.thumbnail,
        ),
      );
    } else {
      return await create(BaseRepoRequest.build(request, request.data.product));
    }
  }

  @override
  Future<ApiResult<PaginationResponse<List<Product>>>> getAllByStoreAndBranchId(
    BaseRepoRequest<PaginationIndexRequest<GetProductRequest>> request,
  ) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> productSnapshot;

      final productUnderStoreCollection = firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS);

      final totalItem = await productUnderStoreCollection.count().get();

      if (request.data.lastDocument != null) {
        if (request.data.payload?.categoryId != null) {
          productSnapshot =
              await productUnderStoreCollection
                  .orderBy('info.createAt', descending: request.data.descending ?? true)
                  .limit(request.data.limit)
                  .startAfterDocument(request.data.lastDocument!)
                  .get();
        } else {
          productSnapshot =
              await productUnderStoreCollection
                  .orderBy('info.createAt', descending: request.data.descending ?? true)
                  .limit(request.data.limit)
                  .startAfterDocument(request.data.lastDocument!)
                  .get();
        }
      } else {
        if (request.data.payload?.categoryId != null) {
          productSnapshot =
              await productUnderStoreCollection
                  .where('category', isEqualTo: request.data.payload?.categoryId, isNull: false)
                  .orderBy('info.createAt', descending: request.data.descending ?? true)
                  .limit(request.data.limit)
                  .get();
        } else {
          productSnapshot =
              await productUnderStoreCollection
                  .orderBy('info.createAt', descending: request.data.descending ?? true)
                  .limit(request.data.limit)
                  .get();
        }
      }

      log('productSnapshot.docs ${productSnapshot.docs}');

      if (productSnapshot.docs.isEmpty) {
        return ApiResult(response: PaginationResponse(data: [], totalItem: totalItem.count ?? 0));
      } else {
        final response = productSnapshot.docs.map((e) => Product.fromJson(e.data())).toList();
        return ApiResult(
          response: PaginationResponse(
            data: response,
            lastDocument: productSnapshot.docs.last,
            totalItem: totalItem.count ?? 0,
          ),
        );
      }
    } catch (e) {
      return ApiResult(error: e);
    }
  }

  @override
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

  @override
  Future<ApiResult<Product>> update(BaseRepoRequest<Product> request) async {
    try {
      log('update product id ${request.data.id}');
      final docRef = firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
          .doc(request.data.id);

      final updatedPayload = request.data.toJson();

      await docRef.update({...updatedPayload, 'info.updateAt': FieldValue.serverTimestamp()});

      return ApiResult(response: request.data);
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  @override
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

  @override
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

  @override
  Future<void> updateHistory(CreateProductHistoryRequest request) async {
    request.info?.createAt = FieldValue.serverTimestamp();

    final docId = DateTime.now().toTransactionFormatId(prefix: ApplicationConstance.orderHistory);

    await firebaseService.storesCollection
        .doc(request.storeId)
        .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
        .doc(request.productId)
        .collection(FirebaseFirestoreConstance.COLLECTION_HISTORY)
        .doc(docId)
        .set(request.toJson());
  }

  @override
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

  @override
  Future<void> addQuantity({
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

      // if ((currentProductTypeQty?.quantity ?? 0) >= reduceQty) {
      final addQty = (currentProductTypeQty?.quantity ?? 0) + reduceQty;

      currentProductType.productTypeList![index!].quantity = addQty;
      await currentProductRef.update({
        'productTypeList': currentProductType.productTypeList?.map((e) => e.toJson()).toList(),
      });
      // }
    } catch (e) {
      log('error reduceQuantity : $e');
    }
  }

  @override
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
              .collection(FirebaseFirestoreConstance.COLLECTION_HISTORY)
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
        if (request.data.imageRefUrl != null) {
          final ref = firebaseService.storage.refFromURL(request.data.imageRefUrl!);
          final newUrl = await ref.getDownloadURL();
          await ref.putFile(request.data.updatedImage!);
          return await update(BaseRepoRequest.build(request, request.data.product!..imageUrl = newUrl));
        } else {
          final resultImageUpload = await createProductProfileImage(request.overide(data: request.data.updatedImage!));
          return await update(
            BaseRepoRequest.build(
              request,
              request.data.product!
                ..imageUrl = resultImageUpload.profile
                ..imageThumbnail = resultImageUpload.thumbnail,
            ),
          );
        }
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

    if (request.data.imageUrl != null) {
      await imageRepository.deleteImageFromStore(BaseRepoRequest.build(request, request.data.imageUrl!));
    }

    return ApiResult(response: 'deleteProduct ${request.data.id} success');
  }

  @override
  Future<ApiResult<List<Product>>> searchProductByKey(BaseRepoRequest<String> request) async {
    try {
      final snapShot =
          await firebaseService.storesCollection
              .doc(request.storeId)
              .collection(FirebaseFirestoreConstance.COLLECTION_PRODUCTS)
              .orderBy('name')
              .startAt([request.data])
              .endAt(['${request.data}\uf8ff']) // "\uf8ff" is a unicode character
              .limit(10)
              .get();

      final products = snapShot.docs.map((e) => Product.fromJson(e.data())).toList();

      return ApiResult(response: products);
    } catch (e) {
      return ApiResult(error: e);
    }
  }
}

class ProductProfileImage {
  final String thumbnail;
  final String profile;
  ProductProfileImage({required this.thumbnail, required this.profile});
}
