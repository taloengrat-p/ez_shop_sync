import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/constances/firebase/firebase_firestore_constance.dart';
import 'package:ez_shop_sync/src/constances/firebase/firebase_storage_constance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  FirebaseStorage get storage => _firebaseStorage;
  User? get user => _firebaseAuth.currentUser;
  String? get userUid => user?.uid;
  String? get userEmail => user?.email;
}
