import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_router.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/widgets/image/image_widget.dart';
import 'package:flutter/material.dart';

class ProductGridItemWidget extends StatelessWidget {
  final Product product;

  const ProductGridItemWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionsKeys.radius),
      ),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageWidget(
            imageUrl: product.image,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(DimensionsKeys.radius),
              topRight: Radius.circular(DimensionsKeys.radius),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name),
                  Text(
                    '\$${product.price.toString()}',
                    style: const TextStyle(color: Colors.orange),
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
