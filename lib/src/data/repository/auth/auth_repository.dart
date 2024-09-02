import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_register_request.dart';
import 'package:ez_shop_sync/src/data/repository/auth/_local/auth_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

abstract class IAuthRepository {
  login();
  logout();
  Future<User> register(CreateRegisterRequest user);
}

@Singleton()
@Injectable()
class AuthRepository implements IAuthRepository {
  AuthLocalRepository authLocalRepository;
  StoreRepository storeRepository;

  AuthRepository({
    required this.authLocalRepository,
    required this.storeRepository,
  });

  @override
  login() {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<User> register(CreateRegisterRequest request, {AppMode? appMode = AppMode.local}) async {
    if (appMode == AppMode.local) {
      final userId = const Uuid().v1();
      final storeId = const Uuid().v1();

      final store = Store(
        id: storeId,
        ownerId: userId,
        name: request.storeName,
        tags: [],
        categories: [],
      );

      final user = User(
        id: userId,
        storeId: [store.id],
        firstName: request.firstName,
        lastName: request.lastName,
        email: request.email,
        username: '${request.firstName}.${request.lastName.substring(0, 1)}'.toLowerCase(),
      );

      await authLocalRepository.create(
        user,
      );

      await storeRepository.create(
        store,
      );

      return user;
    } else {
      throw UnimplementedError();
    }
  }
}
