import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:ez_shop_sync/src/widgets/column_title_value_widget.dart';
import 'package:ez_shop_sync/src/widgets/image_form_field.dart/image_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageFormField extends StatefulWidget {
  final int imageDetailLimit;
  final Function(File? value)? onProductImageSelect;
  final dynamic Function(List<File>? images)? onProductDetailImageSelect;

  const ImageFormField({
    Key? key,
    required this.imageDetailLimit,
    required this.onProductImageSelect,
    required this.onProductDetailImageSelect,
  }) : super(key: key);

  @override
  _ImageFormFieldState createState() => _ImageFormFieldState();
}

class _ImageFormFieldState extends State<ImageFormField> {
  List<File> productDetailImages = [];
  File? productImage;
  CarouselSliderController _carouselController = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColumnTitleValueWidget(
            title: 'Product Image',
            value: ImagePickerWidget(
              width: 140,
              height: 200,
              onImagePicked: (file) {
                if (file.isNotNull) {
                  productImage = file;
                  widget.onProductImageSelect?.call(productImage);
                }
              },
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          if (productDetailImages.isNotEmpty)
            Expanded(
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  viewportFraction: 0.8,
                  height: 140,
                  enableInfiniteScroll: false,
                  initialPage: 0,
                ),
                items: buildCarouselImagePickerDetail(),
              ),
            ),
          const SizedBox(
            width: 8,
          ),
          if (widget.imageDetailLimit != productDetailImages.length)
            Center(
              child: ColumnTitleValueWidget(
                title: 'Detail Image',
                value: ImagePickerWidget(
                  height: productDetailImages.isEmpty ? 100 : 60,
                  width: productDetailImages.isEmpty ? 100 : 60,
                  imageInit: null,
                  disablePreview: true,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  onImagePicked: (file) {
                    if (file.isNotNull) {
                      setState(() {
                        productDetailImages.add(file!);
                      });
                      _carouselController
                          .animateToPage(productDetailImages.length);
                      widget.onProductDetailImageSelect
                          ?.call(productDetailImages);
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
      ...productDetailImages.asMap().map((index, e) {
        return MapEntry(index, Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              child: ColumnTitleValueWidget(
                title: 'Detail ${index + 1}',
                textStyle: const TextStyle(fontSize: 12),
                value: ImagePickerWidget(
                  imageInit: e,
                  height: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  onImagePicked: (file) {
                    if (file.isNotNull) {
                      setState(() {
                        productDetailImages[index] = file!;
                      });
                      widget.onProductDetailImageSelect
                          ?.call(productDetailImages);
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
}
