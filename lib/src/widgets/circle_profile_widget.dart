import 'package:ez_shop_sync/res/colors.dart';
import 'package:flutter/material.dart';

class CircleProfileWidget extends StatelessWidget {
  final String? title;
  final double? radius;
  const CircleProfileWidget({
    super.key,
    this.title,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: CircleAvatar(
        radius: radius ?? 24,
        backgroundColor: ColorKeys.white,
        child: Text(
          title ?? '',
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
