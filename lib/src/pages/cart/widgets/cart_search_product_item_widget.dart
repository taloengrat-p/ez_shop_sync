import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/widgets/image/image_widget.dart';
import 'package:flutter/material.dart';

class CartSearchProductItemWidget extends StatelessWidget {
  final Product product;
  final void Function()? onTap;

  const CartSearchProductItemWidget({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ImageWidget(imageUrl: product.imageThumbnail, width: 40, height: 160, fit: BoxFit.contain),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(product.allQuantity.toString()),
          Text(product.unitType?.shortName.tr(context) ?? LocaleKeys.units_piece.tr()),
        ],
      ),
      title: Text(product.name),
      onTap: onTap,
    );
  }
}
