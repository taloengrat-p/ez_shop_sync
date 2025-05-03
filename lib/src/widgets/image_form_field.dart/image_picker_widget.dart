import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
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
  File? imageEditor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final imagePicked = await ImagePickerUtils.pickImage();

        widget.onImagePicked?.call(imagePicked);

        setState(() {
          imageEditor = imagePicked;
        });
      },
      child: DottedBorder(
        borderType: BorderType.Circle,
        color: Colors.grey,
        strokeWidth: 1,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: widget.path != null
              ? Stack(
                  children: [
                    Center(
                      child: ClipOval(
                        child: Image.file(
                          imageEditor ?? File(widget.path!),
                          width: widget.width,
                          height: widget.height,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Center(
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.grey,
                      ),
                    )
                  ],
                )
              : Container(
                  padding: widget.margin,
                  height: widget.height,
                  width: widget.width,
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
