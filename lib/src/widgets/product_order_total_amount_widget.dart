import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';

class ProductOrderTotalAmountWidget extends StatelessWidget {
  final num? totalPrice;
  const ProductOrderTotalAmountWidget({
    super.key,
    required this.totalPrice,
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
          totalPrice?.prefixCurrency() ?? '--',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
