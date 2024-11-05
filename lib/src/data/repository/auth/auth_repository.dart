import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_register_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/login_request.dart';
import 'package:ez_shop_sync/src/data/repository/auth/_local/auth_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/auth/auth_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

abstract class IAuthRepository {
  Future<ApiResult<auth.UserCredential>> login(LoginRequest request);
  Future<void> logout({AppMode appMode = AppMode.local});
  Future<ApiResult> register(CreateRegisterRequest user, {AppMode appMode = AppMode.local});
}

@Singleton()
@Injectable()
class AuthRepository implements IAuthRepository {
  AuthLocalRepository authLocalRepository;
  AuthServerRepository authServerRepository;
  StoreRepository storeRepository;

  AuthRepository({
    required this.authLocalRepository,
    required this.storeRepository,
    required this.authServerRepository,
  });

  @override
  Future<ApiResult> register(CreateRegisterRequest request, {AppMode? appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      final userId = const Uuid().v1();
      final storeId = const Uuid().v1();

      final store = Store(
        id: storeId,
        ownerId: userId,
        description: 'request.storeDesc',
        name: 'request.storeName',
        tags: [],
        categories: [],
      );

      final user = User(
        id: userId,
        storeId: [store.id],
        firstName: 'request.firstName',
        lastName: 'request.lastName',
        email: request.email,
        // phoneNumber: request.phoneNumber,
        username: '--', // '${request.firstName}.${request.lastName.substring(0, 1)}'.toLowerCase(),
        carts: [],
        addProducts: [],
      );

      await authLocalRepository.create(
        user,
      );

      await storeRepository.create(
        store,
      );

      return ApiResult(response: user);
    } else {
      return authServerRepository.register(request);
    }
  }

  @override
  Future<ApiResult<auth.UserCredential>> login(LoginRequest request) async {
    if (request.appMode == AppMode.local) {
      return ApiResult(error: Exception('Not support offline login'));
    } else {
      return authServerRepository.login(request);
    }
  }

  @override
  Future<void> logout({AppMode appMode = AppMode.local}) async {
    authServerRepository.logout();
  }
}
