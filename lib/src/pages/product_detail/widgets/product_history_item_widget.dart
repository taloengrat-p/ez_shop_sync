import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_history.dart';
import 'package:ez_shop_sync/src/widgets/circle_profile_widget.dart';
import 'package:ez_shop_sync/src/widgets/history_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductHistoryItemWidget extends StatelessWidget {
  final ProductHistory? history;
  final Product? product;
  const ProductHistoryItemWidget({
    super.key,
    this.history,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    return HistoryWidget(
      title: history?.titleDisplay() ?? '',
      desc: history?.descDisplay(product: product) ?? '',
      leading: CircleProfileWidget(
        title: history?.info?.createBy?.substring(0, 2).toUpperCase(),
        radius: 24,
      ),
      dateTime: (history?.info?.createAt as Timestamp?)?.toDate(),
    );
  }
}
