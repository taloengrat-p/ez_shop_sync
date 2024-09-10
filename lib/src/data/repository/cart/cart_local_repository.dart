import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class CartLocalRepository extends BaseHiveRepository<String, Cart> {
  CartLocalRepository() : super(boxName: HiveBoxConstance.cart);

  List<Cart> getByUserIdWithCurrentStore(List<String> cartsId) {
    return getAllById(cartsId);
  }

  Future<Cart> createIfNotExist(Cart cart) async {
    Cart? result = getById(cart.id);
    if (result == null) {
      return await create(cart);
    } else {
      return result;
    }
  }

  Future<Cart> deleteItemByIdFromCart(String? id, String cartItemId) async {
    if (id == null) {
      throw ('id is Null');
    }

    Cart? result = getById(id);

    if (result == null) {
      throw ('Cart get By id $id is Null');
    }

    return await update(
      id,
      result..cartItems.removeWhere((item) => item.id == cartItemId),
    );
  }
}
