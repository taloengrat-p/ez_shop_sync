import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/num_extension.dart';
import 'package:ez_shop_sync/src/widgets/container/container_shadow_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/image_widget.dart';
import 'package:ez_shop_sync/src/widgets/product_order_total_amount_widget.dart';
import 'package:ez_shop_sync/src/widgets/product_info_list_item.dart';
import 'package:ez_shop_sync/src/widgets/text_title_bold_value_widget.dart';
import 'package:flutter/material.dart';

class OrderHistoryItemWidget extends StatelessWidget {
  final ProductOrder order;

  const OrderHistoryItemWidget({
    super.key,
    required this.order,
  });

  OrderItem get firstOrderItem => order.cartItems.first;

  @override
  Widget build(BuildContext context) {
    return ContainerShadowWidget(
      color: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Column(
                children: [
                  TextTitleBoldValueWidget(
                    title: LocaleKeys.orderId.tr(),
                    value: order.id,
                  ),
                  TextTitleBoldValueWidget(
                    title: LocaleKeys.orderDateTime.tr(),
                    value: order.createDate.toDisplayDependLocale(context),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey.shade300,
            ),
            SizedBox(
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ImageWidget(
                    imageUrl: firstOrderItem.product?.imagesPath?.firstOrNull,
                    width: 120,
                    borderRadius: BorderRadius.circular(DimensionsKeys.radius),
                  ),
                  Expanded(
                    child: ProductInfoListItem(
                      padding: const EdgeInsets.all(8),
                      name: firstOrderItem.product?.name ?? '',
                      desc: firstOrderItem.product?.description,
                      price: firstOrderItem.product?.priceCurrentSelected?.prefixCurrency() ?? '--',
                      priceCategory: firstOrderItem.product?.priceSelected,
                    ),
                  ),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     IconButton(
                  //       onPressed: onIncreaseQty,
                  //       icon: Icon(
                  //         Icons.add_circle_outline_rounded,
                  //         color: ColorKeys.primary,
                  //         size: 28,
                  //       ),
                  //     ),
                  //     Text(cartItem.product!.quantity.toString()),
                  //     IconButton(
                  //       onPressed: onDecreaseQty,
                  //       icon: Icon(
                  //         Icons.remove_circle_outline_rounded,
                  //         color: ColorKeys.primary,
                  //         size: 28,
                  //       ),
                  //     )
                  //   ],
                  // ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.orderNumberOfItem.tr(args: [order.numberOfItems.toString()]),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  ProductOrderTotalAmountWidget(productOrder: order),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
