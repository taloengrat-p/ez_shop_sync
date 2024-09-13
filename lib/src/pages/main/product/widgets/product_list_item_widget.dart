import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/pages/main/product/models/product_item.interface.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:ez_shop_sync/src/widgets/container/app_container_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/image_widget.dart';
import 'package:ez_shop_sync/src/widgets/product_info_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProductListItemWidget extends StatelessWidget {
  final Product product;
  final IProductPage iProductItem;

  const ProductListItemWidget({
    super.key,
    required this.product,
    required this.iProductItem,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainerWidget(
      radius: DimensionsKeys.radius + 2,
      backgroundColor: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Slidable(
          closeOnScroll: true,
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  iProductItem.onDelete(product.id);
                },
                padding: EdgeInsets.zero,
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: CupertinoIcons.delete,
                // label: LocaleKeys.delete.tr(),
              ),
              const SizedBox(
                width: 0.5,
              ),
              SlidableAction(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.amber,
                foregroundColor: Colors.white,
                icon: CupertinoIcons.bag_badge_plus,
                // label: LocaleKeys.edit.tr(),
                onPressed: (context) {
                  iProductItem.onAddStock(product);
                },
              ),
              const SizedBox(
                width: 0.5,
              ),
              SlidableAction(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                icon: CupertinoIcons.pencil,
                onPressed: (context) {
                  iProductItem.onEdit(product.id);
                },
                // label: LocaleKeys.edit.tr(),
              ),
              const SizedBox(
                width: 0.5,
              ),
              SlidableAction(
                onPressed: (context) {
                  iProductItem.onAddCart(product);
                },
                padding: EdgeInsets.zero,
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                icon: CupertinoIcons.cart_badge_plus,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                // label: LocaleKeys.edit.tr(),
              ),
            ],
          ),
          child: SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageWidget(
                  imageUrl: product.image,
                  imageFullName: product.imageName,
                  width: 120,
                  height: 120,
                  borderRadius: BorderRadius.circular(DimensionsKeys.radius),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: ProductInfoListItem(
                    padding: const EdgeInsets.all(8.0),
                    name: product.name,
                    desc: product.description,
                    qty: product.quantity,
                    price: product.priceStringDisplay,
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
