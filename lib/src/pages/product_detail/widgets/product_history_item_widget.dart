import 'package:ez_shop_sync/src/data/dto/hive_object/enums/product_history_event.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_history.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/widgets/circle_profile_widget.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleProfileWidget(
            title: history?.createBy?.substring(0, 2).toUpperCase(),
            radius: 24,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: buildInfo(context),
          )
        ],
      ),
    );
  }

  Widget buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(history?.descDisplay(product: product) ?? ''),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            const Icon(
              CupertinoIcons.time_solid,
              color: Colors.grey,
              size: 18,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(history?.createDate?.toDisplayTimeDependLocale(context) ?? ''),
          ],
        )
      ],
    );
  }
}
