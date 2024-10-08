import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/widgets/container/container_price_category_widget.dart';
import 'package:flutter/material.dart';

class ProductInfoListItem extends StatelessWidget {
  final String name;
  final String? desc;
  final String? price;
  final EdgeInsetsGeometry? padding;
  final num? qty;
  final String? priceCategory;

  const ProductInfoListItem({
    super.key,
    required this.name,
    this.desc,
    this.padding,
    this.price,
    this.qty,
    this.priceCategory,
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
          Column(
            children: [
              if (priceCategory != null)
                ContainerPriceCategoryWidget(
                  isSelect: true,
                  label: priceCategory ?? '',
                ),
              if (price != null) ...[
                const SizedBox(
                  height: 8,
                ),
                Text(
                  price!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.orange),
                )
              ],
              if (qty != null)
                Text(
                  LocaleKeys.qty.tr(args: [qty.toString(), LocaleKeys.units_piece.tr()]),
                  style: Theme.of(context).textTheme.titleMedium,
                )
            ],
          ),
        ],
      ),
    );
  }
}
