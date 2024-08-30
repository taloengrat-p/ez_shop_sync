import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:flutter/material.dart';

class ContainerScrollableWidget extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final double? paddingAll;
  final double? radius;
  final EdgeInsets? margin;

  const ContainerScrollableWidget({
    super.key,
    this.backgroundColor,
    required this.child,
    this.paddingAll,
    this.radius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(paddingAll ?? 0),
      margin: margin ?? EdgeInsets.all(paddingAll ?? 0),
      decoration: BoxDecoration(
        color: backgroundColor?.withOpacity(0.1) ??
            ColorKeys.primary.withOpacity(0.1),
        border: Border.all(
          color: backgroundColor ?? ColorKeys.primary.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(radius ?? DimensionsKeys.radius),
      ),
      child: child,
    );
  }
}
