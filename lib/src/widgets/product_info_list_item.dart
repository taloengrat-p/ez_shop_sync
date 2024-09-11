import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_page.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';

import 'package:flutter/material.dart';

class ProductInfoListItem extends StatelessWidget {
  final String name;
  final String? desc;
  final num? price;
  final EdgeInsetsGeometry? padding;
  final num? qty;

  const ProductInfoListItem({
    super.key,
    required this.name,
    this.desc,
    this.padding,
    this.price,
    this.qty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                desc ?? '',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(),
              ),
            ],
          ),
          if (price != null)
            Text(
              price.toString().prefixCurrency(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          if (qty != null)
            Text(
              LocaleKeys.qty.tr(args: [qty.toString(), LocaleKeys.units_piece.tr()]),
              style: Theme.of(context).textTheme.titleMedium,
            )
        ],
      ),
    );
  }
}
