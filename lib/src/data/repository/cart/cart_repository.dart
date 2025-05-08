// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:injectable/injectable.dart';

import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/cart/i_cart_repository.dart';
import 'package:ez_shop_sync/src/data/repository/cart/local/cart_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/cart/server/cart_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/i_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';

@Singleton()
@Injectable()
class CartRepository extends IRepository<Cart> implements ICartRepository {
  CartLocalRepository cartLocalRepository;
  CartServerRepository cartServerRepository;

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

      log('getCartsByUserIdWithCurrentStore() local : result ${result.response}');

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
    if (request.userId == null) {
      throw ('deleteItemByIdFromCart appCubit.user == null');
    }

    if (appMode == AppMode.local) {
      return await cartLocalRepository.deleteItemByIdFromCart(request);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult<Cart>> addCart(BaseRepoRequest<AddCartRequest> request) async {
    if (request.userId == null) {
      throw ('addCart appCubit.user == null');
    }

    if (appMode == AppMode.local) {
      return await cartLocalRepository.addCart(request);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult> increaseQty(BaseRepoRequest<CartIncreaseQtyRequest> request) async {
    if (request.userId == null) {
      throw ('increaseQty request.userId');
    }

    if (appMode == AppMode.local) {
      return await cartLocalRepository.increaseQty(request);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult> decreaseQty(BaseRepoRequest<CartDecreaseQtyRequest> request) async {
    if (request.userId == null) {
      throw ('increaseQty request.userId');
    }

    if (appMode == AppMode.local) {
      return await cartLocalRepository.decreaseQty(
        request.data.cartId,
        request.data.productId,
        request.data.qty,
        storeId: request.storeId ?? '',
        userId: request.storeId ?? '',
      );
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
      return await cartLocalRepository.getAllById(ids);
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
    // TODO: implement deleteAll
    throw UnimplementedError();
  }
}

class CartDecreaseQtyRequest {
  String? cartId;
  String? productId;
  num qty;
  CartDecreaseQtyRequest({this.cartId, this.productId, required this.qty});
}

class CartIncreaseQtyRequest {
  String? cartId;
  String? productId;
  num qty;
  CartIncreaseQtyRequest({this.cartId, this.productId, required this.qty});
}

class AddCartRequest {
  String id;
  Product product;
  AddCartRequest({required this.id, required this.product});
}

class DeleteItemFromCartRequest {
  String? id;
  String cartItemId;
  DeleteItemFromCartRequest({this.id, required this.cartItemId});
}
