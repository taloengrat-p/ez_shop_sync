import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:flutter/material.dart';

class TextButtonWidget extends TextButton {
  TextButtonWidget({
    super.key,
    required super.onPressed,
    required super.child,
    required Color backgroundColor,
  }) : super(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(backgroundColor),
            textStyle: WidgetStatePropertyAll(
              TextStyle(
                color: backgroundColor.getContrast(),
              ),
            ),
          ),
        );
}
