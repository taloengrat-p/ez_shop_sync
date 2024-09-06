import 'package:flutter/material.dart';

class DrawableIconWidget extends StatelessWidget {
  final String drawable;
  final double? width;
  final double? height;
  const DrawableIconWidget(
    this.drawable, {
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      drawable,
      width: width ?? 24,
      height: height ?? 24,
    );
  }
}
