import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';

class AddProductStockRequest {
  String id;
  OrderItem orderItem;

  AddProductStockRequest({required this.id, required this.orderItem});
}
