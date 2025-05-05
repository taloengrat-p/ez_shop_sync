import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_register_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/login_request.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class IAuthRepository {
  Future<ApiResult<auth.UserCredential>> login(LoginRequest request);
  Future<void> logout({AppMode appMode = AppMode.local});
  Future<ApiResult> register(CreateRegisterRequest user, {AppMode appMode = AppMode.local});
}
