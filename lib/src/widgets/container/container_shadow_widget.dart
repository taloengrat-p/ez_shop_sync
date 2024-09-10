import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:flutter/material.dart';

class ContainerShadowWidget extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  const ContainerShadowWidget({
    super.key,
    required this.child,
    this.color,
    this.borderRadius,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        borderRadius: BorderRadius.circular(DimensionsKeys.radius),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1), //(x,y)
            blurRadius: 8.0,
          ),
        ],
      ),
      child: child,
    );
  }
}
