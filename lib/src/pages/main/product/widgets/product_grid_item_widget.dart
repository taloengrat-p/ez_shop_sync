import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/pages/main/product/models/product_item.interface.dart';
import 'package:ez_shop_sync/src/widgets/container/app_container_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/image_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/row_between_widget.dart';
import 'package:ez_shop_sync/src/widgets/opacity_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductGridItemWidget extends StatelessWidget {
  final Product product;
  final IProductPage? iProductItem;

  const ProductGridItemWidget({
    super.key,
    required this.product,
    this.iProductItem,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainerWidget(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageWidget(
            imageUrl: product.image,
            imageFullName: product.imageName,
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(4),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(DimensionsKeys.radius),
              topRight: Radius.circular(DimensionsKeys.radius),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          product.priceStringDisplay,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.orange),
                        ),
                        if (product.quantity != null)
                          Text(
                            overflow: TextOverflow.ellipsis,
                            LocaleKeys.qty.tr(
                              args: [
                                product.quantity?.toString() ?? '',
                                LocaleKeys.units_piece.tr(),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    color: Colors.white,
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem(
                        onTap: () {
                          iProductItem?.onAddCart(product);
                        },
                        child: OpacityWidget(
                          child: RowBetweenWidget(
                            title: Text(LocaleKeys.addCart.tr()),
                            value: const Icon(
                              CupertinoIcons.cart_badge_plus,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: OpacityWidget(
                          child: RowBetweenWidget(
                            title: Text(LocaleKeys.addStock.tr()),
                            value: const Icon(
                              CupertinoIcons.bag_badge_plus,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        onTap: () {
                          iProductItem?.onAddStock(product);
                        },
                      ),
                      PopupMenuItem(
                        onTap: () {
                          iProductItem?.onEdit(product.id);
                        },
                        child: OpacityWidget(
                          child: RowBetweenWidget(
                            title: Text(LocaleKeys.edit.tr()),
                            value: const Icon(CupertinoIcons.pencil),
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        child: RowBetweenWidget(
                          title: Text(
                            LocaleKeys.delete.tr(),
                          ),
                          value: const Icon(
                            CupertinoIcons.delete,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {
                          iProductItem?.onDelete(product.id);
                        },
                      ),
                    ],
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Icon(Icons.more_vert_rounded),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
