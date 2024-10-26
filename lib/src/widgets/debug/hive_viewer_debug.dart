import 'dart:developer';

import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_ui/boxes_view.dart';

class HiveViewerDebug extends StatefulWidget {
  const HiveViewerDebug({super.key});

  @override
  _HiveViewerDebugState createState() => _HiveViewerDebugState();
}

class _HiveViewerDebugState extends State<HiveViewerDebug> {
  @override
  Widget build(BuildContext context) {
    return HiveBoxesView(
      hiveBoxes: {
        Hive.box<ProductOrder>(HiveBoxConstance.order): (json) => ProductOrder.fromJson(json),
        Hive.box<Cart>(HiveBoxConstance.cart): (json) => Cart.fromJson(json),
        Hive.box<Store>(HiveBoxConstance.store): (json) => Store.fromJson(json),
        Hive.box<Product>(HiveBoxConstance.product): (json) => Product.fromJson(json),
      },
      onError: (error) {
        log('error $error');
      },
    );
  }
}
