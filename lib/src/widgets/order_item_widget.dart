import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/utils/extensions/num_extension.dart';
import 'package:ez_shop_sync/src/widgets/container/container_shadow_widget.dart';
import 'package:ez_shop_sync/src/widgets/divider_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/image_widget.dart';
import 'package:ez_shop_sync/src/widgets/product_info_list_item.dart';
import 'package:flutter/material.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderItem? order;

  const OrderItemWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return ContainerShadowWidget(
      color: Colors.white,
      borderRadius: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ImageWidget(
                    imageUrl: order?.product?.imageThumbnail,
                    width: 120,
                    borderRadius: BorderRadius.circular(DimensionsKeys.radius),
                  ),
                  Expanded(
                    child: ProductInfoListItem(
                      padding: const EdgeInsets.all(8),
                      name: order?.product?.name ?? '',
                      desc: order?.product?.description,
                      qty: order?.product?.quantity,
                      price: order?.product?.priceCurrentSelected?.prefixCurrency() ?? '--',
                      priceCategory: order?.product?.productTypeSelectDisplay,
                    ),
                  ),
                ],
              ),
            ),
            if (order?.note != null) ...[const DividerWidget(), Text(order?.note ?? '--')],
          ],
        ),
      ),
    );
  }
}
