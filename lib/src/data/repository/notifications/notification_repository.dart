import 'package:ez_shop_sync/src/constances/firebase/firebase_firestore_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/notification.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/i_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';
import 'package:ez_shop_sync/src/services/firebase_service.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class NotificationRepository extends IRepository<Notification> {
  final FirebaseService firebaseService;

  NotificationRepository({required this.firebaseService, required super.navigationService}) : super(AppMode.server);

  Future<ApiResult> createInvite({required String uid, required Notification request}) async {
    try {
      await firebaseService.usersCollection
          .doc(uid)
          .collection(FirebaseFirestoreConstance.COLLECTION_NOTIFICATIONS)
          .add(request.toJson());

      return ApiResult(response: {"status": "Success"});
    } catch (e) {
      return ApiResult(error: e);
    }
  }

  Future<ApiResult<List<Notification>>> getNotifications() async {
    try {
      final userNotificationCollection =
          await firebaseService.usersCollection
              .doc(firebaseService.userUid)
              .collection(FirebaseFirestoreConstance.COLLECTION_NOTIFICATIONS)
              .get();

      return ApiResult(
        response:
            userNotificationCollection.docs.map((e) {
              var notificationItem = Notification.fromJson(e.data());
              return notificationItem..id = e.id;
            }).toList(),
      );
    } catch (e) {
      return ApiResult(error: {}, appErrorType: AppErrorType.somethingWentWrong);
    }
  }

  Future<void> removeInvitation(String? notiId) async {
    await firebaseService.usersCollection
        .doc(firebaseService.userUid)
        .collection(FirebaseFirestoreConstance.COLLECTION_NOTIFICATIONS)
        .doc(notiId)
        .delete();
  }

  @override
  Future<ApiResult<Notification>> create(BaseRepoRequest<Notification> request) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<ApiResult> delete(BaseRepoRequest<String> request) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> deleteAllByIds(List<String> ids) {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<List<Notification>>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<List<Notification>>> getAllByIds(List<String> ids) {
    // TODO: implement getAllByIds
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Notification>> getById(BaseRepoRequest<String> request) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Notification>> update(BaseRepoRequest<Notification> request) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<ApiResult> deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }
}
