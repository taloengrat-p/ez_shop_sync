import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/widgets/container/app_container_widget.dart';
import 'package:ez_shop_sync/src/widgets/dialogs/confirm_dialog_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/image_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/row_between_widget.dart';
import 'package:ez_shop_sync/src/widgets/opacity_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductGridItemWidget extends StatelessWidget {
  final Product product;
  final Function()? onDelete;

  const ProductGridItemWidget({
    super.key,
    required this.product,
    this.onDelete,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name),
                      Text(
                        '\฿${product.price?.toString() ?? '--'}',
                        style: const TextStyle(color: Colors.orange),
                      ),
                      if (product.quantity != null)
                        Text(
                          LocaleKeys.qty.tr(
                            args: [
                              product.quantity?.toString() ?? '',
                              LocaleKeys.units_piece.tr(),
                            ],
                          ),
                        )
                    ],
                  ),
                  PopupMenuButton(
                    color: Colors.white,
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem(
                        child: OpacityWidget(
                          disabled: true,
                          child: RowBetweenWidget(
                            title: Text(LocaleKeys.addStock.tr()),
                            value: Icon(CupertinoIcons.bag_badge_plus),
                          ),
                        ),
                        onTap: () {},
                      ),
                      PopupMenuItem(
                        child: OpacityWidget(
                          disabled: true,
                          child: RowBetweenWidget(
                            title: Text(LocaleKeys.edit.tr()),
                            value: const Icon(CupertinoIcons.pencil),
                          ),
                        ),
                        onTap: () {},
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
                          ConfirmDialogUiWidget(
                            context,
                            title: LocaleKeys.confirmDeleteTitle.tr(),
                            desc: LocaleKeys.confirmDeleteDesc.tr(),
                            confirmLabel: LocaleKeys.delete.tr(),
                            confirmColor: Colors.red,
                          ).show().then(
                            (val) {
                              if (val == ConfirmDialogUiResult.ok) {
                                onDelete?.call();
                              }
                            },
                          );
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
