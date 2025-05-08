import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/drawables.dart';
import 'package:ez_shop_sync/src/widgets/container/app_container_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/empty_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatefulWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool? disabledDecoration;
  final Color? backgroundColor;

  final BoxFit? fit;
  const ImageWidget({
    super.key,
    this.fit,
    this.borderRadius,
    this.imageUrl,
    this.width,
    this.height,
    this.margin = const EdgeInsets.all(4),
    this.padding = const EdgeInsets.all(4),
    this.disabledDecoration = false,
    this.backgroundColor,
  });

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  File? _imageFile;
  BoxDecoration containerDecoration(Color color) =>
      BoxDecoration(borderRadius: widget.borderRadius ?? BorderRadius.circular(DimensionsKeys.radius), color: color);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) async {
      // final document = await getApplicationDocumentsDirectory();

      final filePath = widget.imageUrl;
      if (filePath != null) {
        if (File(filePath).existsSync()) {
          setState(() {
            _imageFile = File(filePath);
          });
        } else {
          // print('File not found at path: $filePath');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      child: AppContainerWidget(
        radius: 10,
        margin: widget.margin,
        padding: widget.padding,
        width: widget.width ?? double.infinity,
        height: widget.height ?? 200,
        decoration: BoxDecoration(borderRadius: widget.borderRadius),
        child:
            _imageFile != null
                ? Image.file(
                  _imageFile!,
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return buildErrorImage();
                  },
                )
                : widget.imageUrl != null
                ? CachedNetworkImage(
                  fit: widget.fit ?? BoxFit.fitWidth,
                  imageUrl: widget.imageUrl!,

                  placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
                  errorWidget: (context, url, error) => buildErrorImage(),
                )
                : const EmptyImage(),
      ),
    );
  }

  Widget buildErrorImage() {
    return Stack(
      children: [
        Center(child: Image.asset(Drawables.emptyImage)),
        Container(
          alignment: Alignment.center,
          decoration: containerDecoration(Colors.grey.withOpacity(0.4)),
          child: Icon(Icons.error_outline_rounded, color: Colors.red.shade400, size: 120),
        ),
      ],
    );
  }
}
