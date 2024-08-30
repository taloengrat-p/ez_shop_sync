import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:flutter/material.dart';

class AppContainerWidget extends StatelessWidget {
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Widget child;
  final Color? backgroundColor;
  final BoxDecoration? decoration;
  final double? width;
  final double? height;
  final double? radius;
  const AppContainerWidget({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.width,
    this.height,
    this.decoration,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      height: height,
      width: width,
      decoration: decoration ??
          BoxDecoration(
            color: backgroundColor ?? Colors.white,
            border: Border.all(
                color: ColorKeys.primary.withOpacity(0.3), width: 0.5),
            borderRadius: BorderRadius.circular(
              radius ?? DimensionsKeys.radius,
            ),
          ),
      child: child,
    );
  }
}
