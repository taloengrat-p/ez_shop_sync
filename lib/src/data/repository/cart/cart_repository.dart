// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/cart_request/add_cart_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/cart_request/cart_decrease_qty_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/cart_request/cart_increase_qty_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/cart_request/delete_item_from_cart_request.dart';
import 'package:ez_shop_sync/src/data/repository/cart/i_cart_repository.dart';
import 'package:ez_shop_sync/src/data/repository/cart/local/i_cart_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/cart/server/i_cart_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/i_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class CartRepository extends IRepository<Cart> implements ICartRepository {
  ICartLocalRepository cartLocalRepository;
  ICartServerRepository cartServerRepository;

  CartRepository({
    required this.cartLocalRepository,
    required this.cartServerRepository,
    required super.navigationService,
  }) : super(AppMode.local);

  @override
  Future<ApiResult<Cart>> create(BaseRepoRequest<Cart> request) async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.createIfNotExist(request);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> delete(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.delete(request.data);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> deleteAllByIds(List<String> ids) async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<Cart>> getCartsByUserIdWithCurrentStore({required String storeId, required String userId}) async {
    if (appMode == AppMode.local) {
      final result = await cartLocalRepository.getCartByStoreAndUserId(storeId: storeId, userId: userId);

      return result;
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<Cart>> update(BaseRepoRequest<Cart> request) async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.update(request);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult<Cart>> deleteItemByIdFromCart(BaseRepoRequest<DeleteItemFromCartRequest> request) async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.deleteItemByIdFromCart(request);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult<Cart>> addCart(BaseRepoRequest<AddCartRequest> request) async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.addCart(request);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult> increaseQty(BaseRepoRequest<CartIncreaseQtyRequest> request) async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.increaseQty(request);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult> decreaseQty(BaseRepoRequest<CartDecreaseQtyRequest> request) async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.decreaseQty(request);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<Cart>>> getAll() async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.getAll();
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<Cart>>> getAllByIds(List<String> ids) async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.getAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<Cart>> getById(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.getById(request.data);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> deleteAll() {
    throw UnimplementedError();
  }
}
