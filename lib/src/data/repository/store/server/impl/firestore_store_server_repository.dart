import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/constances/firebase/firebase_firestore_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/branch.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/role_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/member.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/notification.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/unit_type.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/store_request/add_branch_request.dart';
import 'package:ez_shop_sync/src/data/repository/notifications/notification_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/server/store_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';
import 'package:ez_shop_sync/src/pages/add_user/add_user_cubit.dart';
import 'package:ez_shop_sync/src/services/firebase_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: StoreServerRepository, env: [Flavor.DEV, Flavor.STG, Flavor.PROD])
@Singleton(as: StoreServerRepository, env: [Flavor.DEV, Flavor.STG, Flavor.PROD])
class FirestoreStoreServerRepository implements StoreServerRepository {
  final UserRepository userRepository;
  final FirebaseService firebaseService;
  final NotificationRepository notificationRepository;

  FirestoreStoreServerRepository({
    required this.userRepository,
    required this.firebaseService,
    required this.notificationRepository,
  });

  @override
  Future<ApiResult<Store>> create(BaseRepoRequest<Store> request) async {
    final productInfo = BaseHiveData(
      createAt: FieldValue.serverTimestamp(),
      updateAt: FieldValue.serverTimestamp(),
      createBy: request.data.ownerId,
      updateBy: request.data.ownerId,
    );

    request.data.info = productInfo;

    final storeCreated = await firebaseService.storesCollection.add(request.data.toJson());

    final response = await storeCreated.get();

    if (response.data() == null) {
      return ApiResult(error: null, appErrorType: AppErrorType.somethingWentWrong);
    }

    firebaseService.usersCollection.doc(firebaseService.userUid).set({
      'stores': FieldValue.arrayUnion([storeCreated.id]),
    }, SetOptions(merge: true));

    await userRepository.updateSelectedBranchUnderStore(request);

    return ApiResult(response: request.data..id = response.id);
  }

  @override
  Future<ApiResult<List<Store>>> getAll() async {
    try {
      final userResponse = await firebaseService.usersCollection.doc(firebaseService.userUid).get();
      final userData = userResponse.data();
      final List storesOfUser = userData?['stores'];

      var snapshots = await Future.wait(
        storesOfUser.map((id) => firebaseService.storesCollection.doc(id).get()).toList(),
      );

      List<Store> stores =
          snapshots.map((snapshot) {
            var store = Store.fromJson(snapshot.data() ?? {});
            return store..id = snapshot.id;
          }).toList();

      return ApiResult(response: stores);
    } catch (e) {
      return ApiResult(response: []);
    }
  }

  @override
  Future<ApiResult> sendInviteToStore(BaseRepoRequest<StoreSendInvite> request) async {
    try {
      var user = await firebaseService.usersCollection.get();

      if (user.docs.any((e) => e.get('email') == request.data.email)) {
        var storeResponse = await firebaseService.storesCollection.doc(request.data.storeId).get();
        final store = Store.fromJson(storeResponse.data() ?? {});
        if (store.members.any((e) => e.email == request.data.email)) {
          return ApiResult(error: {}, appErrorType: AppErrorType.storeAlreadyThisUser);
        }

        notificationRepository.createInvite(
          uid: user.docs.firstWhere((e) => e.get('email') == request.data.email).id,
          request: Notification(
            type: NotificationType.storeInvite,
            title: request.data.storeName,
            createAt: FieldValue.serverTimestamp(),
            payload: {'storeId': request.data.storeId, 'role': request.data.role.name},
          ),
        );

        return ApiResult(response: {"status": "Success"});
      } else {
        return ApiResult(error: {}, appErrorType: AppErrorType.userNotFound);
      }
    } catch (e) {
      return ApiResult(error: e);
    }
  }

  @override
  Future<ApiResult> acceptInvitation(String? notiId, String? storeId, Map<String, dynamic>? payload) async {
    // try {
    await firebaseService.storesCollection.doc(storeId).set({
      'members': FieldValue.arrayUnion([
        Member(
          uid: firebaseService.userUid ?? '',
          role: payload?['role'],
          email: firebaseService.userEmail ?? '',
        ).toJson(),
      ]),
    }, SetOptions(merge: true));
    await firebaseService.usersCollection.doc(firebaseService.userUid).set({
      'stores': FieldValue.arrayUnion([storeId]),
    }, SetOptions(merge: true));

    await notificationRepository.removeInvitation(notiId);

    return ApiResult(response: {"status": "Success"});
    // } catch (e) {
    //   return ApiResult(
    //     error: e,
    //   );
    // }
  }

  @override
  Future<ApiResult> rejectInvitation() async {
    try {
      return ApiResult(response: {"status": "Success"});
    } catch (e) {
      return ApiResult(error: e);
    }
  }

  @override
  Future<ApiResult<Branch>> createBranch(BaseRepoRequest<AddBranchRequest> request) async {
    try {
      final branchRef = firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_BRANCHES);

      final querySnapshot = await branchRef.where('name', isEqualTo: request.data.name).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        return ApiResult(
          error: LocaleKeys.errorMessage_alreadyExist.tr(args: [request.data.name]),
          appErrorType: AppErrorType.alreadyExist,
        );
      }

      final branchId = DateTime.now().toTransactionFormatId(prefix: ApplicationConstance.branchPrefix);

      final storeRef = await firebaseService.storesCollection.doc(request.storeId).get();
      final store = Store.fromJson(storeRef.data() ?? {});
      final payload = Branch(
        id: branchId,
        name: request.data.name,
        info: BaseHiveData(
          createAt: FieldValue.serverTimestamp(),
          updateAt: FieldValue.serverTimestamp(),
          branchId: branchId,
          storeId: request.storeId,
          updateBy: request.userId,
          createBy: request.userId,
        ),
        members: store.members.where((e) => e.roleType == RoleType.owner).toList(),
      );
      await branchRef.doc(branchId).set(payload.toJson());

      return ApiResult(response: payload);
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  @override
  Future<ApiResult<List<Branch>>> getStoreBranches(BaseRepoRequest<Null> request) async {
    try {
      final branchRef = firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_BRANCHES);

      final querySnapshot = await branchRef.orderBy('info.createAt', descending: false).get();

      List<Branch> branches =
          querySnapshot.docs.map((snapshot) {
            var store = Branch.fromJson(snapshot.data());
            return store..id = snapshot.id;
          }).toList();

      return ApiResult(response: branches);
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  @override
  Future<ApiResult> deleteBranch(BaseRepoRequest request) async {
    try {
      final branchRef = firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_BRANCHES)
          .doc(request.data);

      await branchRef.delete();

      return ApiResult(response: 'Delete ${request.data} success');
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  @override
  Future<ApiResult<List<Branch>>> getAllBranchesByStoreIds(BaseRepoRequest<List<String>> request) async {
    try {
      final branchRef = await Future.wait(
        request.data
            .map(
              (e) =>
                  firebaseService.storesCollection
                      .doc(e)
                      .collection(FirebaseFirestoreConstance.COLLECTION_BRANCHES)
                      .orderBy('info.createAt', descending: false)
                      .get(),
            )
            .toList(),
      );

      final branchList = branchRef.expand((e) => e.docs.map((e) => Branch.fromJson(e.data()))).toList();
      final branchFiltered = branchList.where((e) => e.members.map((e) => e.uid).contains(request.userId)).toList();
      return ApiResult(response: branchFiltered);
    } catch (e) {
      return ApiResult(error: e, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  @override
  Future<ApiResult> deleteUnitTypeByIds(BaseRepoRequest<List<String>> request) {
    // TODO: implement deleteUnitTypeByIds
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<UnitType>> createUnitTypes(BaseRepoRequest<UnitType> request) async {
    try {
      final unitTypeId = DateTime.now().toTransactionFormatId(prefix: ApplicationConstance.unitTypePrefix);
      final payload = request.data.copyWith(
        id: unitTypeId,
        info: BaseHiveData(
          storeId: request.storeId,
          createBy: request.userId,
          updateBy: request.userId,
          branchId: request.branchId,
          createAt: FieldValue.serverTimestamp(),
          updateAt: FieldValue.serverTimestamp(),
        ),
      );
      await firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_UNIT_TYPES)
          .doc(unitTypeId)
          .set(payload.toJson());

      return ApiResult(response: payload);
    } catch (e) {
      return ApiResult(error: e);
    }
  }

  @override
  Future<ApiResult<List<UnitType>>> getUnitTypes(BaseRepoRequest<Null> request) async {
    try {
      final refUnitTypes = firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_UNIT_TYPES);

      final refDocs = await refUnitTypes.get();
      final docs = refDocs.docs;
      final unitTypes = docs.map((e) => UnitType.fromJson(e.data())).toList();
      return ApiResult(response: unitTypes);
    } catch (e) {
      return ApiResult(error: e);
    }
  }

  @override
  Future<ApiResult<UnitType>> updateUnitType(BaseRepoRequest<UnitType> request) async {
    try {
      final payload = {...request.data.toJson(), 'info.updateAt': FieldValue.serverTimestamp()};
      final refUnitTypes = firebaseService.storesCollection
          .doc(request.storeId)
          .collection(FirebaseFirestoreConstance.COLLECTION_UNIT_TYPES)
          .doc(request.data.id);

      await refUnitTypes.update(payload);

      return ApiResult(response: request.data);
    } catch (e) {
      return ApiResult(error: e);
    }
  }
}
