import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:flutter/material.dart';

class ButtonIconLabelWidget extends StatelessWidget {
  final Widget icon;
  final String label;
  final TextStyle? labelStyle;
  final double gap;
  final Color? color;
  final Function()? onPressed;
  const ButtonIconLabelWidget({
    super.key,
    required this.icon,
    required this.label,
    this.labelStyle,
    this.gap = 4,
    this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(
              height: gap,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FittedBox(
                child: Text(
                  label,
                  style: labelStyle?.copyWith(
                    color: color?.getContrast(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
