import 'package:ez_shop_sync/res/colors.dart';
import 'package:flutter/material.dart';

class ContainerCircleWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double iconSize;

  const ContainerCircleWidget({
    super.key,
    required this.child,
    this.onPressed,
    this.color,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed != null ? 1 : 0.5,
      child: Container(
        padding: padding,
        margin: margin,
        width: iconSize * 2,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: onPressed == null ? Colors.grey.withOpacity(0.4) : color ?? ColorKeys.primary),
        ),
        child: IconButton(
          iconSize: iconSize,
          onPressed: onPressed,
          color: onPressed == null ? Colors.grey.withOpacity(0.4) : color ?? ColorKeys.primary,
          icon: child,
        ),
      ),
    );
  }
}
