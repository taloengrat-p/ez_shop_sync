import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:ez_shop_sync/src/utils/image_picker_utils.dart';
import 'package:flutter/material.dart';

class ImagePickerWidget extends StatefulWidget {
  final double? height;
  final double? width;
  final EdgeInsets? margin;
  final Function(File? file)? onImagePicked;
  final String? path;
  final bool disablePreview;
  final BoxConstraints? constraints;
  const ImagePickerWidget({
    super.key,
    this.height,
    this.width,
    this.margin,
    this.onImagePicked,
    this.path,
    this.disablePreview = false,
    this.constraints,
  });

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? image;

  @override
  void initState() {
    super.initState();
    if (widget.path != null) {
      setState(() {
        image = File(widget.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final imagePicked = await ImagePickerUtils.pickImage();

        if (!widget.disablePreview) {
          if (imagePicked.isNotNull) {
            setState(() {
              image = imagePicked;
            });
          }
        }

        widget.onImagePicked?.call(imagePicked);
      },
      child: DottedBorder(
        color: Colors.grey,
        strokeWidth: 1,
        child: image != null
            ? Container(
                constraints: widget.constraints,
                height: widget.height,
                child: Image.file(
                  image!,
                  fit: BoxFit.contain,
                  width: widget.width,
                  height: widget.height,
                ),
              )
            : Container(
                padding: widget.margin,
                height: widget.height,
                width: widget.width,
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.red,
                  ),
                ),
              ),
      ),
    );
  }
}
