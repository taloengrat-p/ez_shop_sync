import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/models/enums/cart_error_type.enum.dart';
import 'package:ez_shop_sync/src/utils/extensions/num_extension.dart';
import 'package:ez_shop_sync/src/widgets/container/container_shadow_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/image_widget.dart';
import 'package:ez_shop_sync/src/widgets/product_info_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AddProductItemWidget extends StatelessWidget {
  final OrderItem? orderItem;
  final Function()? onIncreaseQty;
  final Function()? onDecreaseQty;
  final Function()? onDelete;
  // final bool hasError;
  final CartErrorType? errorMessageType;
  const AddProductItemWidget({
    super.key,
    required this.orderItem,
    // this.hasError = false,
    this.onDecreaseQty,
    this.onIncreaseQty,
    this.onDelete,
    this.errorMessageType,
  });

  String get getErrorMessageLabel => switch (errorMessageType) {
    CartErrorType.insufficient => LocaleKeys.error_productPriceNotEnough.tr(),
    CartErrorType.invalid => LocaleKeys.error_productInvalid.tr(),
    CartErrorType.undefined => 'undefined',
    null => throw UnimplementedError(),
    // TODO: Handle this case.
  };

  @override
  Widget build(BuildContext context) {
    return ContainerShadowWidget(
      color: Colors.white,
      borderRadius: 20,
      borderColor: errorMessageType != null ? Colors.red : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Slidable(
          closeOnScroll: true,
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  onDelete?.call();
                },
                padding: EdgeInsets.zero,
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: CupertinoIcons.delete,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
              ),
              const SizedBox(width: 0.5),
            ],
          ),
          child: SizedBox(
            height: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ImageWidget(
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        imageUrl: orderItem?.product?.imageThumbnail,
                        width: 120,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      Expanded(
                        child: ProductInfoListItem(
                          padding: const EdgeInsets.all(8),
                          name: orderItem?.product?.name ?? '',
                          desc: orderItem?.product?.description ?? '',
                          price: orderItem?.cost?.prefixCurrency() ?? '--',
                          priceCategory: orderItem?.product?.productTypeSelectDisplay ?? '--',
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: onIncreaseQty,
                            icon: Icon(Icons.add_circle_outline_rounded, color: ColorKeys.primary, size: 28),
                          ),
                          Text(orderItem?.product?.quantity.toString() ?? '--'),
                          IconButton(
                            onPressed: onDecreaseQty,
                            icon: Icon(Icons.remove_circle_outline_rounded, color: ColorKeys.primary, size: 28),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (errorMessageType != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.error_rounded, size: 14, color: Colors.red),
                        const SizedBox(width: 4),
                        Text(
                          getErrorMessageLabel,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
