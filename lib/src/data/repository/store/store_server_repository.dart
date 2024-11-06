import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/notification.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/repository/notifications/notification_repository.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';
import 'package:ez_shop_sync/src/services/firebase_service.dart';
import 'package:injectable/injectable.dart';

@Injectable()
@Singleton()
class StoreServerRepository {
  final UserRepository userRepository;
  final FirebaseService firebaseService;
  final NotificationRepository notificationRepository;
  StoreServerRepository({
    required this.userRepository,
    required this.firebaseService,
    required this.notificationRepository,
  });

  Future<ApiResult<Store>> create(Store request) async {
    request.createDate = FieldValue.serverTimestamp();

    final storeCreated = await firebaseService.storesCollection.add(
      request.toJson(),
    );

    final response = await storeCreated.get();

    if (response.data() == null) {
      return ApiResult(error: null, appErrorType: AppErrorType.somethingWentWrong);
    }

    firebaseService.usersCollection.doc(firebaseService.userUid).set(
        {
          'stores': FieldValue.arrayUnion([storeCreated.id]),
        },
        SetOptions(
          merge: true,
        ));

    await userRepository.updateSelectedStore(response.id);

    return ApiResult(response: request..id = response.id);
  }

  Future<ApiResult<List<Store>>> getAll() async {
    try {
      final userResponse = await firebaseService.usersCollection.doc(firebaseService.userUid).get();
      final userData = userResponse.data();
      final List storesOfUser = userData?['stores'];

      var snapshots = await Future.wait(
        storesOfUser.map((id) => firebaseService.storesCollection.doc(id).get()).toList(),
      );

      List<Store> stores = snapshots.map(
        (snapshot) {
          var store = Store.fromJson(snapshot.data() ?? {});
          return store..id = snapshot.id;
        },
      ).toList();

      return ApiResult(response: stores);
    } catch (e) {
      return ApiResult(response: []);
    }
  }

  Future<ApiResult> sendInviteToStore({
    required storeId,
    required String email,
    String? storeName,
  }) async {
    try {
      var user = await firebaseService.usersCollection.get();

      if (user.docs.any((e) => e.get('email') == email)) {
        var storeResponse = await firebaseService.storesCollection.doc(storeId).get();
        final store = Store.fromJson(storeResponse.data() ?? {});
        if (store.members.any((e) => e.email == email)) {
          return ApiResult(error: {}, appErrorType: AppErrorType.storeAlreadyThisUser);
        }

        notificationRepository.createInvite(
          uid: user.docs.firstWhere((e) => e.get('email') == email).id,
          request: Notification(
            type: NotificationType.storeInvite,
            title: storeName,
            createAt: FieldValue.serverTimestamp(),
          ),
        );
        return ApiResult(
          response: {"status": "Success"},
        );
      } else {
        return ApiResult(error: {}, appErrorType: AppErrorType.userNotFound);
      }
    } catch (e) {
      return ApiResult(error: e);
    }
  }
}
