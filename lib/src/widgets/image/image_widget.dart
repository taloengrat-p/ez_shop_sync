import 'dart:developer' as dev;
import 'dart:io';

import 'package:ez_shop_sync/res/image_constance.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/utils/extensions/list_string_extensions.dart';
import 'package:ez_shop_sync/src/widgets/image/empty_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImageWidget extends StatefulWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final String? imageFullName;
  final BorderRadiusGeometry? borderRadius;

  const ImageWidget({
    Key? key,
    this.borderRadius,
    this.imageUrl,
    this.width,
    this.height,
    this.imageFullName,
  }) : super(key: key);

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  File? _imageFile;
  BoxDecoration containerDecoration(Color color) => BoxDecoration(
        borderRadius:
            widget.borderRadius ?? BorderRadius.circular(DimensionsKeys.radius),
        color: color,
      );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) async {
      final document = await getApplicationDocumentsDirectory();

      final filePath = [document.path, widget.imageFullName].toJoinPath();
      if (File(filePath).existsSync()) {
        setState(() {
          _imageFile = File(filePath);
        });
      } else {
        print('File not found at path: $filePath');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 200,
      decoration: containerDecoration(Colors.grey.shade200),
      child: _imageFile != null
          ? Image.file(
              _imageFile!,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                dev.log('error build image $error');
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
