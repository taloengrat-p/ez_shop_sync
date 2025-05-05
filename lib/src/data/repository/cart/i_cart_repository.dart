import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';

abstract class ICartRepository {
  Future<ApiResult<Cart>> getCartsByUserIdWithCurrentStore({required String storeId, required String userId});

  // Future<Cart> create(Cart request);
  // Future<Cart> update(String id, Cart updated);
  // Future<void> delete(String id);
  // Future<void> deleteAll(List<String> ids);
}
