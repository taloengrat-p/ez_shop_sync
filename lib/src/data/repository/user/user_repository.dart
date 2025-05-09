import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user_data.dart';
import 'package:ez_shop_sync/src/data/repository/notifications/notification_repository.dart';
import 'package:ez_shop_sync/src/services/firebase_service.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class UserRepository {
  final FirebaseService firebaseService;
  final NotificationRepository notificationRepository;

  UserRepository({required this.firebaseService, required this.notificationRepository});

  Future<bool> onCheckUserAlreadyUseApp() async {
    if (firebaseService.user == null) {
      throw Exception('user == null');
    }
    var currentUserRow = await firebaseService.usersCollection.doc(firebaseService.userUid).get();

    return currentUserRow.exists;
  }

  Future<void> initialUserData() async {
    if (firebaseService.user == null) {
      throw Exception('user == null');
    }
    final userUid = firebaseService.userUid;
    var currentUserRow = firebaseService.usersCollection.doc(userUid);

    await currentUserRow.set({
      'uid': userUid,
      'email': firebaseService.user?.email,
      'displayName': firebaseService.user?.displayName,
    }, SetOptions(merge: true));
  }

  Future<ApiResult> updateSelectedStore(id) async {
    try {
      if (firebaseService.user == null) {
        throw Exception('user == null');
      }

      var currentUserRow = firebaseService.usersCollection.doc(firebaseService.userUid);

      await currentUserRow.set({'storeSelected': id}, SetOptions(merge: true));

      return ApiResult(response: id);
    } catch (e) {
      return ApiResult(error: id);
    }
  }

  Future<ApiResult<UserData>> getUserData() async {
    try {
      if (firebaseService.user == null) {
        throw Exception('user == null');
      }

      var currentUserRow = await firebaseService.usersCollection.doc(firebaseService.userUid).get();

      return ApiResult(response: UserData.fromJson(currentUserRow.data() ?? {}));
    } catch (e) {
      return ApiResult(error: e);
    }
  }
}
