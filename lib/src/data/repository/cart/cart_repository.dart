import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/base_repository.dart';
import 'package:ez_shop_sync/src/data/repository/cart/cart_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/cart/cart_server_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';

abstract class ICartRepository {
  List<Cart> getCartsByUserIdWithCurrentStore(List<String> request);
  Future<Cart> create(Cart request);
  Future<Cart> update(String id, Cart updated);
  Future<void> delete(String id);
  Future<void> deleteAll(List<String> ids);
}

@Singleton()
@Injectable()
class CartRepository extends BaseRepository implements ICartRepository {
  CartLocalRepository cartLocalRepository;
  CartServerRepository cartServerRepository;

  CartRepository({
    required this.cartLocalRepository,
    required this.cartServerRepository,
  });

  @override
  Future<Cart> create(Cart request) async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.createIfNotExist(request);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> delete(String id) async {
    if (appMode == AppMode.local) {
      await cartLocalRepository.delete(id);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> deleteAll(List<String> ids) async {
    if (appMode == AppMode.local) {
      await cartLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  List<Cart> getCartsByUserIdWithCurrentStore(List<String> carts) {
    if (appMode == AppMode.local) {
      return cartLocalRepository.getAllById(carts);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<Cart> update(String id, Cart updated) async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.update(id, updated);
    } else {
      throw UnimplementedError();
    }
  }

  Future<Cart> deleteItemByIdFromCart(String? id, String cartItemId) async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.deleteItemByIdFromCart(id, cartItemId);
    } else {
      throw UnimplementedError();
    }
  }

  Future<Cart?> addCart(String id, Product product) async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.addCart(id, product);
    } else {
      throw UnimplementedError();
    }
  }

  Future<void> increaseQty(String? cartId, String? productId, num qty) async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.increaseQty(cartId, productId, qty);
    } else {
      throw UnimplementedError();
    }
  }

  Future<void> decreaseQty(String? cartId, String? productId, num qty) async {
    if (appMode == AppMode.local) {
      return await cartLocalRepository.decreaseQty(cartId, productId, qty);
    } else {
      throw UnimplementedError();
    }
  }
}
