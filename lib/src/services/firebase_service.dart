import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/constances/firebase/firebase_firestore_constance.dart';
import 'package:ez_shop_sync/src/constances/firebase/firebase_storage_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class FirebaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instanceFor(
    databaseId: F.appFlavor.name == 'dev' ? 'easy-store-dev' : '(default)',
    app: Firebase.app(),
  );
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instanceFor(
    bucket: F.appFlavor.name == 'dev' ? 'gs://ez-shop-dev-98ded' : 'gs://ez-shop-dev-98ded',
    app: Firebase.app(),
  );

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseRemoteConfig _firebaseRemoteConfig = FirebaseRemoteConfig.instance;

  CollectionReference<Map<String, dynamic>> get usersCollection =>
      _firebaseFirestore.collection(FirebaseFirestoreConstance.COLLECTION_USERS);
  CollectionReference<Map<String, dynamic>> get productCollection =>
      _firebaseFirestore.collection(FirebaseFirestoreConstance.COLLECTION_STORE);
  CollectionReference<Map<String, dynamic>> get storesCollection =>
      _firebaseFirestore.collection(FirebaseFirestoreConstance.COLLECTION_STORE);
  CollectionReference<Map<String, dynamic>> get notificationCollection =>
      _firebaseFirestore.collection(FirebaseFirestoreConstance.COLLECTION_NOTIFICATIONS);

  Reference get storeStorage => _firebaseStorage.ref().child(FirebaseStorageConstance.COLLECTION_STORES);
  Reference get userStorage => _firebaseStorage.ref().child(FirebaseStorageConstance.COLLECTION_USERS);
  FirebaseMessaging get firebaseMessaging => _firebaseMessaging;
  FirebaseStorage get storage => _firebaseStorage;
  FirebaseRemoteConfig get remoteConfig => _firebaseRemoteConfig;
  FirebaseAuth get firebaseAuth => _firebaseAuth;
  User? get user => _firebaseAuth.currentUser;
  String? get userUid => user?.uid;
  String? get userEmail => user?.email;

  FirebaseService() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Show in-app notification or dialog
      log('onMessage : ${message.toString()}', name: runtimeType.toString());
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Navigate to relevant page
      log('onMessageOpenedApp : ${message.toString()}', name: runtimeType.toString());
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await usersCollection.doc(userUid).update({'fcmToken': newToken});
    });

    firebaseAuth.userChanges().listen((User? user) {
      log('userChanges() $user', name: runtimeType.toString());
      GetIt.I<AppCubit>().setCurrentUser(user, origin: runtimeType.toString());
      updateUserFcmToken(user?.uid);
    });
  }

  Future<ApiResult> updateUserFcmToken(String? userId) async {
    throwIf(userId == null, 'can not updateUserFcmToken userId == null');
    try {
      // Request permission (required on iOS)
      NotificationSettings settings = await firebaseMessaging.requestPermission();

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Wait for APNs to be ready on iOS
        await Future.delayed(const Duration(seconds: 1));

        // Now get the FCM token

        final token = await firebaseMessaging.getToken();

        if (token != null) {
          await usersCollection.doc(userId).update({'fcmToken': token});
        }
        return ApiResult(response: 'Update user fcm token $token');
      }
      return ApiResult(response: 'Update user fcm token unsuccess.');
    } catch (e) {
      return ApiResult(error: e);
    }
  }
}
