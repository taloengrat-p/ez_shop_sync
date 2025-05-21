// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';

class ProductCategoryGroup {
  List<Product> products;
  QueryDocumentSnapshot? lastDocument;
  ProductCategoryGroup({required this.products, this.lastDocument});
}
