import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
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
    return Card(
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                onDeleteProduct?.call();
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: CupertinoIcons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Row(
          children: [
            ImageWidget(
              imageUrl: product.image,
              width: 60,
              height: 100,
              borderRadius: BorderRadius.circular(DimensionsKeys.radius),
            ),
            Text(product.name),
          ],
        ),
      ),
    );
  }
}
