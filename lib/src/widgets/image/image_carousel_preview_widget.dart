import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:flutter/material.dart';

class ImageCarouselPreviewWidget extends StatefulWidget {
  final List<String> imagesUrl;
  final double height;
  const ImageCarouselPreviewWidget({
    Key? key,
    required this.imagesUrl,
    this.height = 200,
  }) : super(key: key);

  @override
  State<ImageCarouselPreviewWidget> createState() => _ImageCarouselPreviewWidgetState();
}

class _ImageCarouselPreviewWidgetState extends State<ImageCarouselPreviewWidget> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: widget.height,
              enableInfiniteScroll: false,
              initialPage: 0,
              onPageChanged: (index, reason) {
                setState(() {
                  currentPage = index;
                });
              },
            ),
            items: widget.imagesUrl.map(
              (e) {
                return Image.file(File(e));
              },
            ).toList(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              margin: const EdgeInsets.only(right: 8, bottom: 8),
              child: Text(
                '${currentPage + 1}/${widget.imagesUrl.length}',
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DimensionsKeys.radius),
                color: Colors.grey.withOpacity(0.8),
              ),
            ),
          )
        ],
      ),
    );
  }
}
