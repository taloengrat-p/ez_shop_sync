// ignore_for_file: constant_identifier_names

import 'package:ez_shop_sync/src/pages/create_product/create_product_page.dart';
import 'package:ez_shop_sync/src/pages/introduce/introduce_page.dart';
import 'package:ez_shop_sync/src/pages/main/main_page.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String ROUTE_MAIN = '/MAIN';
  static const String ROUTE_CREATE_PRODUCT = '/ROUTE_CREATE_PRODUCT';
  static const String ROUTE_PRODUCT_DETAIL = '/ROUTE_PRODUCT_DETAIL';
  static const String ROUTE_INTRODUCE = '/ROUTE_INTRODUCE';

  static Map<String, Widget Function(BuildContext)> values = {
    ROUTE_MAIN: (context) => const MainPage(),
    ROUTE_CREATE_PRODUCT: (context) => const CreateProductPage(),
    ROUTE_PRODUCT_DETAIL: (context) => const ProductDetailPage(),
    ROUTE_INTRODUCE: (context) => const IntroduceFlowPage(),
  };
}
