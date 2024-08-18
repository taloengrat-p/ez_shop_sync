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
  final File? imageInit;
  final bool disablePreview;
  const ImagePickerWidget({
    Key? key,
    this.height,
    this.width,
    this.margin,
    this.onImagePicked,
    this.imageInit,
    this.disablePreview = false,
  }) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.imageInit.isNotNull) {
      setState(() {
        image = widget.imageInit;
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
            ? Image.file(
                image!,
                fit: BoxFit.contain,
                width: widget.width,
                height: widget.height,
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
