import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:flutter/material.dart';

class ContainerShadowWidget extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final BorderRadius? border;
  final BoxConstraints? boxConstraints;
  const ContainerShadowWidget({
    super.key,
    required this.child,
    this.color,
    this.borderColor,
    this.borderRadius,
    this.margin,
    this.padding,
    this.border,
    this.boxConstraints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      constraints: boxConstraints,
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        borderRadius: border ?? BorderRadius.circular(borderRadius ?? DimensionsKeys.radius),
        border: Border.all(color: borderColor ?? Colors.white),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1), //(x,y)
            blurRadius: 1.0,
          ),
        ],
      ),
      child: child,
    );
  }
}
