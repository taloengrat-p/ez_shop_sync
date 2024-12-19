import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/src/constances/firebase/firebase_firestore_constance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class FirebaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get usersCollection =>
      _firebaseFirestore.collection(FirebaseFirestoreConstance.COLLECTION_USERS);
  CollectionReference<Map<String, dynamic>> get productCollection =>
      _firebaseFirestore.collection(FirebaseFirestoreConstance.COLLECTION_STORE);
  CollectionReference<Map<String, dynamic>> get storesCollection =>
      _firebaseFirestore.collection(FirebaseFirestoreConstance.COLLECTION_STORE);
  CollectionReference<Map<String, dynamic>> get notificationCollection =>
      _firebaseFirestore.collection(FirebaseFirestoreConstance.COLLECTION_NOTIFICATIONS);

  User? get user => _firebaseAuth.currentUser;
  String? get userUid => user?.uid;
  String? get userEmail => user?.email;
}
