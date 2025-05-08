import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';

class OrderHistoryResponse {
  final List<ProductOrder> orders;
  final QueryDocumentSnapshot? lastDocument;

  OrderHistoryResponse({required this.orders, this.lastDocument});
}
