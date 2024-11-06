import 'package:ez_shop_sync/src/constances/firebase/firebase_firestore_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/notification.dart';
import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';
import 'package:ez_shop_sync/src/services/firebase_service.dart';

import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class NotificationRepository {
  final FirebaseService firebaseService;
  NotificationRepository({
    required this.firebaseService,
  });

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
      final userNotificationCollection = await firebaseService.usersCollection
          .doc(firebaseService.userUid)
          .collection(FirebaseFirestoreConstance.COLLECTION_NOTIFICATIONS)
          .get();

      return ApiResult(
        response: userNotificationCollection.docs.map((e) {
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
}
