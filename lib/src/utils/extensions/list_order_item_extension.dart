import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';

extension ListOrderItemExtension on List<OrderItem> {
  num get numberOfItems => fold(00, (sum, item) => sum + (item.product?.quantity ?? 0));

  num get totalPrice => fold(0.00, (sum, item) => sum + ((item.product?.priceCurrentSelected ?? 0)));

  String get totalItems => fold<num>(00, (sum, item) => sum + (item.product?.quantity ?? 0)).toString();

  num get subTotalPrice => totalPrice;
}
