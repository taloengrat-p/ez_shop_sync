import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_register_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/login_request.dart';
import 'package:ez_shop_sync/src/data/repository/auth/i_auth_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';
import 'package:firebase_auth/firebase_auth.dart' as server;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class AuthServerRepository implements IAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<void> logout({AppMode appMode = AppMode.local}) async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<ApiResult<UserCredential>> login(LoginRequest request) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: request.username,
        password: request.password,
      );

      return ApiResult(response: userCredential);
    } on FirebaseAuthException catch (e) {
      AppErrorType appErrorType = AppErrorType.undefined;
      if (e.code == 'invalid-credential') {
        appErrorType = AppErrorType.invalidCredential;
      } else if (e.code == 'user-not-found') {
        appErrorType = AppErrorType.userNotFound;
      } else if (e.code == 'wrong-password') {
        appErrorType = AppErrorType.wrongPassword;
      }

      return ApiResult(error: e, appErrorType: appErrorType);
    }
  }

  @override
  Future<ApiResult<server.UserCredential>> register(
    CreateRegisterRequest request, {
    AppMode appMode = AppMode.local,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: request.email,
        password: request.password,
      );

      return ApiResult(response: userCredential);
    } on FirebaseAuthException catch (e) {
      AppErrorType appErrorType = AppErrorType.undefined;
      if (e.code == 'invalid-email') {
        appErrorType = AppErrorType.invalidCredential;
      } else if (e.code == 'user-not-found') {
        appErrorType = AppErrorType.userNotFound;
      } else if (e.code == 'wrong-password') {
        appErrorType = AppErrorType.wrongPassword;
      } else if (e.code == 'email-already-in-use') {
        appErrorType = AppErrorType.emailAlreadyInUse;
      }

      return ApiResult(error: e, appErrorType: appErrorType);
    }
  }
}
