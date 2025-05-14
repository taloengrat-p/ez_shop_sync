import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/num_extension.dart';
import 'package:ez_shop_sync/src/widgets/container/container_shadow_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/image_widget.dart';
import 'package:ez_shop_sync/src/widgets/product_order_total_amount_widget.dart';
import 'package:ez_shop_sync/src/widgets/product_info_list_item.dart';
import 'package:ez_shop_sync/src/widgets/text_title_bold_value_widget.dart';
import 'package:flutter/material.dart';

class AddProductHistoryItemWidget extends StatelessWidget {
  final AddProduct addProduct;

  const AddProductHistoryItemWidget({super.key, required this.addProduct});

  OrderItem get firstOrderItem => addProduct.addProductItems.first;

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
                  TextTitleBoldValueWidget(title: LocaleKeys.orderId.tr(), value: addProduct.id),
                  TextTitleBoldValueWidget(
                    title: LocaleKeys.orderDateTime.tr(),
                    value: addProduct.info?.createAtDateTime.toDisplayDependLocale(context) ?? '--',
                  ),
                  TextTitleBoldValueWidget(
                    title: LocaleKeys.paymentMethod.tr(),
                    value: addProduct.getPaymentType.display,
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade300),
            SizedBox(
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(width: 8),
                  ImageWidget(
                    width: 120,
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    imageUrl: firstOrderItem.product?.imageThumbnail,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  Expanded(
                    child: ProductInfoListItem(
                      padding: const EdgeInsets.all(8),
                      name: firstOrderItem.product?.name ?? '',
                      desc: firstOrderItem.product?.description,
                      price: firstOrderItem.product?.priceCurrentSelected?.prefixCurrency() ?? '--',
                      priceCategory: firstOrderItem.product?.productTypeSelectDisplay,
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
                    LocaleKeys.orderNumberOfItem.tr(args: [addProduct.numberOfItems.toString()]),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  ProductOrderTotalAmountWidget(totalPrice: addProduct.amountCost),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
