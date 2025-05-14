import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/models/option_item.dart';
import 'package:ez_shop_sync/src/utils/bottom_sheet_utils.dart';
import 'package:ez_shop_sync/src/utils/image_picker_utils.dart';
import 'package:ez_shop_sync/src/widgets/image/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final double? height;
  final double? width;
  final EdgeInsets? margin;
  final Function(File? file)? onImagePicked;
  final String? path;
  final String? imageUrl;
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
    this.imageUrl,
  });

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('build picker image ${widget.imageUrl}');
    return GestureDetector(
      onTap: () async {
        final result = await BottomSheetUtils.showMenu(context, [
          OptionItem(
            title: LocaleKeys.imagePicker_camera.tr(),
            value: ImageSource.camera,
            leading: const Icon(Icons.photo_camera),
          ),
          OptionItem(
            title: LocaleKeys.imagePicker_gallary.tr(),
            value: ImageSource.gallery,
            leading: const Icon(Icons.photo_library),
          ),
        ]);

        handleImagePickerResult(result);
      },
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child:
            widget.path != null
                ? Stack(
                  children: [
                    Center(
                      // child: ClipOval(
                      // child:
                          child: Image.file(
                            File(widget.path!),
                            width: widget.width,
                            height: widget.height,
                            fit: BoxFit.contain,
                          ),

                      // ),
                    ),
                    const Center(child: Icon(Icons.camera_alt_rounded, color: Colors.grey)),
                  ],
                )
                : widget.imageUrl != null
                ? ImageWidget(imageUrl: widget.imageUrl)
                : Container(
                  padding: widget.margin,
                  height: widget.height,
                  width: widget.width,
                  child: const Center(child: Icon(Icons.camera_alt_rounded, color: Colors.grey)),
                ),
      ),
      // child: DottedBorder(
      //   borderType: BorderType.Circle,
      //   color: Colors.grey,
      //   strokeWidth: 1,
      //   child: ,
      //   ),
      // ),
    );
  }

  void handleImagePickerResult(result) async {
    if (result == ImageSource.camera) {
      final imagePicked = await ImagePickerUtils.pickImage(imageSource: ImageSource.camera);

      if (imagePicked != null) {
        widget.onImagePicked?.call(imagePicked);

        // setState(() {
        //   imageEditor = imagePicked;
        // });
      }
    } else if (result == ImageSource.gallery) {
      final imagePicked = await ImagePickerUtils.pickImage(imageSource: ImageSource.gallery);

      if (imagePicked != null) {
        widget.onImagePicked?.call(imagePicked);

        // setState(() {
        //   imageEditor = imagePicked;
        // });
      }
    }
  }
}
