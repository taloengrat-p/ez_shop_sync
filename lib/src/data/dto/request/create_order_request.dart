import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/payment_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';

class CreateOrderRequest extends BaseRepoRequest {
  Cart cart;
  String storeCode;
  PaymentType paymentType;
  CreateOrderRequest({
    required this.storeCode,
    required super.storeId,
    required super.userId,
    required this.cart,
    required this.paymentType,
  });
}
