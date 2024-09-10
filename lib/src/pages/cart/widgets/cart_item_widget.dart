import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart_item.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:ez_shop_sync/src/widgets/container/container_shadow_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final Function()? onIncreaseQty;
  final Function()? onDecreaseQty;
  final Function()? onDelete;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    this.onDecreaseQty,
    this.onIncreaseQty,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerShadowWidget(
      color: Colors.white,
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
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                // label: LocaleKeys.delete.tr(),
              ),
              const SizedBox(
                width: 0.5,
              ),
            ],
          ),
          child: SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageWidget(
                  imageUrl: cartItem.product?.image,
                  imageFullName: cartItem.product?.imageName,
                  width: 120,
                  height: 120,
                  borderRadius: BorderRadius.circular(DimensionsKeys.radius),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItem.product?.name ?? '',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              cartItem.product?.description ?? '',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(),
                            ),
                          ],
                        ),
                        if (cartItem.product?.price != null)
                          Text(
                            (cartItem.product!.price! * cartItem.product!.quantity!).toString().prefixCurrency(),
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: onIncreaseQty,
                      icon: Icon(
                        Icons.add_circle_outline_rounded,
                        color: ColorKeys.primary,
                        size: 28,
                      ),
                    ),
                    Text(cartItem.product!.quantity.toString()),
                    IconButton(
                      onPressed: onDecreaseQty,
                      icon: Icon(
                        Icons.remove_circle_outline_rounded,
                        color: ColorKeys.primary,
                        size: 28,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
