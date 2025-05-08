import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/widgets/image/empty_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageCarouselPreviewWidget extends StatefulWidget {
  final List<String> imagesUrl;
  final double height;
  const ImageCarouselPreviewWidget({super.key, required this.imagesUrl, this.height = 200});

  @override
  State<ImageCarouselPreviewWidget> createState() => _ImageCarouselPreviewWidgetState();
}

class _ImageCarouselPreviewWidgetState extends State<ImageCarouselPreviewWidget> {
  int currentPage = 0;
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          if (widget.imagesUrl.isNotEmpty)
            Container(
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(widget.imagesUrl[index]),
                    initialScale: PhotoViewComputedScale.contained * 0.8,
                    heroAttributes: PhotoViewHeroAttributes(tag: widget.imagesUrl[index]),
                  );
                },
                itemCount: widget.imagesUrl.length,
                loadingBuilder:
                    (context, event) => Center(
                      child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          value: event == null ? 0 : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
                        ),
                      ),
                    ),
                backgroundDecoration: const BoxDecoration(color: Colors.white),
                pageController: _pageController,
                // onPageChanged: onPageChanged,
              ),
            ),
          // CarouselSlider(
          //   options: CarouselOptions(
          //     height: widget.height,
          //     enableInfiniteScroll: false,
          //     initialPage: 0,
          //     onPageChanged: (index, reason) {
          //       setState(() {
          //         currentPage = index;
          //       });
          //     },
          //   ),
          //   items:
          //       widget.imagesUrl.map((e) {
          //         return ImageWidget(
          //           imageUrl: e,
          //           margin: const EdgeInsets.all(4),
          //           padding: const EdgeInsets.all(4),

          //           disabledDecoration: true,
          //         );
          //       }).toList(),
          // ),
          if (widget.imagesUrl.isEmpty)
            Container(height: widget.height, alignment: Alignment.center, child: const EmptyImage()),
          if (widget.imagesUrl.isNotEmpty)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                margin: const EdgeInsets.only(right: 8, bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(DimensionsKeys.radius),
                  color: Colors.grey.withOpacity(0.8),
                ),
                child: Text(
                  '${currentPage + 1}/${widget.imagesUrl.length}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
