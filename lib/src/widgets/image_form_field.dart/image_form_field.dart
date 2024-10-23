import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ez_shop_sync/src/widgets/column_title_value_widget.dart';
import 'package:ez_shop_sync/src/widgets/image_form_field.dart/image_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageFormField extends StatefulWidget {
  final int imageDetailLimit;
  final dynamic Function(List<String>? images)? onImageSelectChange;
  final List<String> imageUrlItems;

  const ImageFormField({
    super.key,
    required this.imageDetailLimit,
    required this.onImageSelectChange,
    required this.imageUrlItems,
  });

  @override
  _ImageFormFieldState createState() => _ImageFormFieldState();
}

class _ImageFormFieldState extends State<ImageFormField> {
  final List<File> _imageList = [];

  final CarouselSliderController _carouselController = CarouselSliderController();

  List<String> get imagePathList => _imageList.map((e) => e.path).toList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.imageUrlItems.isEmpty)
            ColumnTitleValueWidget(
              value: ImagePickerWidget(
                height: 200,
                width: 250,
                onImagePicked: (file) {
                  if (file != null) {
                    setState(() {
                      _imageList.add(file);
                      doCallBacktoParent();
                    });
                  }
                },
              ),
            ),
          if (widget.imageUrlItems.isNotEmpty)
            Expanded(
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  viewportFraction: 0.8,
                  enableInfiniteScroll: false,
                  initialPage: 0,
                ),
                items: buildCarouselImagePickerDetail(),
              ),
            ),
          const SizedBox(
            width: 8,
          ),
          if ((widget.imageDetailLimit != widget.imageUrlItems.length) && widget.imageUrlItems.isNotEmpty)
            Center(
              child: ColumnTitleValueWidget(
                value: ImagePickerWidget(
                  height: 60,
                  width: 60,
                  path: null,
                  disablePreview: true,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  onImagePicked: (file) {
                    if (file != null) {
                      setState(() {
                        _imageList.add(file);
                      });

                      doCallBacktoParent();
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> buildCarouselImagePickerDetail() {
    return [
      ...widget.imageUrlItems.asMap().map((index, e) {
        return MapEntry(index, Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              child: ColumnTitleValueWidget(
                title: '${index + 1} / ${widget.imageUrlItems.length}',
                textStyle: const TextStyle(fontSize: 12),
                value: ImagePickerWidget(
                  constraints: const BoxConstraints(maxHeight: 180),
                  // height: 200,
                  path: e,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  onImagePicked: (file) {
                    if (file != null) {
                      setState(() {
                        _imageList[index] = file;
                      });
                      widget.onImageSelectChange?.call(imagePathList);
                    }
                  },
                ),
              ),
            );
          },
        ));
      }).values,
    ];
  }

  void doCallBacktoParent() {
    // _carouselController.animateToPage(_imageList.length);
    widget.onImageSelectChange?.call(imagePathList);
  }
}
