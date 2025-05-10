import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';

class AddProductHistoryResponse {
  final List<AddProduct> orders;
  final QueryDocumentSnapshot? lastDocument;

  AddProductHistoryResponse({required this.orders, this.lastDocument});
}
