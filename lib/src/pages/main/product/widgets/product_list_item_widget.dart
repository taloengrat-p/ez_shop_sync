import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/widgets/container/app_container_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProductListItemWidget extends StatelessWidget {
  final Product product;
  final Function()? onDeleteProduct;
  const ProductListItemWidget({
    Key? key,
    required this.product,
    this.onDeleteProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppContainerWidget(
      radius: DimensionsKeys.radius + 2,
      backgroundColor: Colors.white,
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                onDeleteProduct?.call();
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: CupertinoIcons.delete,
              label: 'Delete',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ],
        ),
        child: Row(
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
            Text(product.name),
          ],
        ),
      ),
    );
  }
}
