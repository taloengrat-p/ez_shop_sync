import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_shop_sync/src/widgets/container/app_container_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/empty_image.dart';
import 'package:ez_shop_sync/src/widgets/image/image_error_widet.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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

  @override
  void initState() {
    // if (widget.imageUrl != null) {

    // }
    // Stream<FileResponse> stream = cacheManager.getFileStream(widget.imageUrl!, withProgress: true);

    // stream
    //     .listen((response) {
    //       if (response is FileInfo) {
    //         // This could be from cache (if it's the first event and no DownloadProgress preceded it for this specific call)
    //         // or after a download.
    //         // To be more certain it's a cache hit, you'd ideally check if it's the *very first* emission
    //         // and no DownloadProgress events occur.
    //         print('File available: ${response.originalUrl}, Source: ${response.source}');
    //         // response.source can be FileSource.Cache or FileSource.Online
    //         if (response.source == FileSource.Cache) {
    //           print('Image ${response.originalUrl} was loaded from cache via stream.');
    //         } else if (response.source == FileSource.Online) {
    //           print('Image ${response.originalUrl} was downloaded via stream.');
    //         }
    //       } else if (response is DownloadProgress) {
    //         print('Downloading ${response.originalUrl}: ${response.progress}');
    //       }
    //     })
    //     .onError((error) {
    //       print('Error streaming file: $error');
    //     });

    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((time) async {
    //   // final document = await getApplicationDocumentsDirectory();

    //   final filePath = widget.imageUrl;
    //   if (filePath != null) {
    //     if (File(filePath).existsSync()) {
    //       setState(() {
    // _imageFile = File(filePath);
    //       });
    //     } else {
    //       // print('File not found at path: $filePath');
    //     }
    //   }
    // });
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
                    return const ImageErrorWidet();
                  },
                )
                : widget.imageUrl != null
                ? CachedNetworkImage(
                  key: ValueKey(widget.imageUrl),
                  fit: widget.fit ?? BoxFit.fitWidth,
                  imageUrl: widget.imageUrl!,
                  placeholder: (context, url) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade500,
                      highlightColor: Colors.grey.shade300,
                      child: Container(
                        height: 200,
                        width: 100,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) => const ImageErrorWidet(),
                )
                : const EmptyImage(),
      ),
    );
  }
}
