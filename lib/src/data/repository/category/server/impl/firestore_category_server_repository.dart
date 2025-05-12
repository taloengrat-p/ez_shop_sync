// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/constances/firebase/firebase_firestore_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:injectable/injectable.dart';

import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/category/server/i_category_server_repository.dart';
import 'package:ez_shop_sync/src/services/firebase_service.dart';

@Injectable(as: ICategoryServerRepository, env: [Flavor.DEV, Flavor.STG, Flavor.PROD])
class FirestoreCategoryServerRepository implements ICategoryServerRepository {
  final FirebaseService firebaseService;

  FirestoreCategoryServerRepository({required this.firebaseService});

  @override
  Future<ApiResult<Category>> create(BaseRepoRequest<Category> request) async {
    try {
      final categoryRef = firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_BRANCHES)
          .doc(request.branchId);
      final cateId = DateTime.now().toTransactionFormatId(prefix: ApplicationConstance.productPrefix);
      final payload = request.data.copyWith(
        id: cateId,
        info: BaseHiveData(
          storeId: request.storeId,
          branchId: request.branchId,
          createAt: FieldValue.serverTimestamp(),
          updateAt: FieldValue.serverTimestamp(),
          updateBy: request.userId,
          createBy: request.userId,
        ),
      );

      await categoryRef.set(payload.toJson());

      return ApiResult(response: payload);
    } catch (e) {
      return ApiResult(error: e);
    }
  }

  @override
  Future<ApiResult<List<Category>>> getCategoryByStoreId(BaseRepoRequest<Null> request) async {
    try {
      final categoryRef = firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_CATEGORIES);

      final categorySnapshot = await categoryRef.get();
      final categoryList = categorySnapshot.docs.map((e) => Category.fromJson(e.data())).toList();
      return ApiResult(response: categoryList);
    } catch (e) {
      return ApiResult(error: e);
    }
  }
}
