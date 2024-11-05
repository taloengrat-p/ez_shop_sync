import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/src/constances/firebase/firebase_firestore_constance.dart';
import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class UserRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserRepository();

  Future<bool> onCheckUserAlreadyUseApp() async {
    try {
      await _firebaseFirestore.collection('users').add({
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'createdAt': Timestamp.now(),
      });

      print("Document added successfully!");
    } catch (e) {
      print("Error adding document: $e");
    }

    return false;
    if (_firebaseAuth.currentUser == null) {
      throw Exception('_firebaseAuth.currentUser == null');
    }

    // final usersData = await users.doc(_firebaseAuth.currentUser!.uid).get();

    return false;
  }
}
