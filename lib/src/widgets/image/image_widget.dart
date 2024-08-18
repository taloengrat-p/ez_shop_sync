import 'dart:io';

import 'package:ez_shop_sync/res/image_constance.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:ez_shop_sync/src/widgets/image/empty_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;

  final BorderRadiusGeometry? borderRadius;

  const ImageWidget({
    Key? key,
    this.borderRadius,
    this.imageUrl,
    this.width,
    this.height,
  }) : super(key: key);

  BoxDecoration containerDecoration(Color color) => BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(DimensionsKeys.radius),
        color: color,
      );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 200,
      decoration: containerDecoration(Colors.grey.shade200),
      child: imageUrl.isNotNull
          ? Image.file(
              File(imageUrl!),
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Stack(
                  children: [
                    Center(child: Image.asset(Drawables.emptyImage)),
                    Container(
                      alignment: Alignment.center,
                      decoration: containerDecoration(
                        Colors.grey.withOpacity(0.4),
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        color: Colors.red.shade400,
                        size: 120,
                      ),
                    ),
                  ],
                );
              },
            )
          : const EmptyImage(),
    );
  }
}
