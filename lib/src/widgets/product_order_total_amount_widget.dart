import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:flutter/material.dart';

class ProductOrderTotalAmountWidget extends StatelessWidget {
  final ProductOrder? productOrder;
  const ProductOrderTotalAmountWidget({
    super.key,
    required this.productOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${LocaleKeys.totalAmount.tr()} : ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          productOrder?.totalPriceDisplay ?? '--',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
