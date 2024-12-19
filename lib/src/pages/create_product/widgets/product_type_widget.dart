import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_type.dart';
import 'package:flutter/material.dart';

class ProductTypeWidget extends StatefulWidget {
  final ProductType model;
  const ProductTypeWidget({
    super.key,
    required this.model,
  });

  @override
  _ProductTypeWidgetState createState() => _ProductTypeWidgetState();
}

class _ProductTypeWidgetState extends State<ProductTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.model.image == null
        ? DottedBorder(
            child: const SizedBox(
              width: 60,
              height: double.infinity,
              child: Icon(
                Icons.edit,
                color: Colors.grey,
              ),
            ),
          )
        : Container(
            alignment: Alignment.center,
            width: 60,
            height: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (widget.model.image?.startsWith("http") ?? false)
                  CachedNetworkImage(
                    imageUrl: widget.model.image!,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                if (!(widget.model.image?.startsWith("http") ?? false)) Image.asset(widget.model.image!),
                const Icon(
                  Icons.edit,
                  color: Colors.grey,
                )
              ],
            ),
          );
  }
}
