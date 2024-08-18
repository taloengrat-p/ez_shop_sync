import 'package:ez_shop_sync/res/colors.dart';
import 'package:flutter/material.dart';

enum ButtonUiEffect {
  backgroundRipple,
  labelRipple,
}

enum ButtonUiType {
  primary,
  secondary,
}

class ButtonWidget extends StatefulWidget {
  final ButtonUiType? type;
  final String label;
  final Function()? onPressed;
  final double? radius;
  final double? height;
  final double? elevation;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Widget? leading;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? gap;
  final bool isFittedLabel;
  final ButtonUiEffect? buttonUiEffect;
  final Icon? icon;
  final bool? ripple;
  final double? width;
  final Color borderColor;
  const ButtonWidget({
    Key? key,
    this.type,
    required this.label,
    this.onPressed,
    this.radius,
    this.backgroundColor,
    this.textStyle,
    this.leading,
    this.padding,
    this.margin,
    this.gap,
    this.height = 56,
    this.isFittedLabel = true,
    this.elevation,
    this.buttonUiEffect,
    this.icon,
    this.ripple = true,
    this.width = double.infinity,
    this.borderColor = Colors.transparent,
  }) : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  bool isPressed = false;
  SizedBox buildIcon() {
    if (widget.icon != null) {
      return SizedBox(
        width: 50.0, // Adjust as needed
        child: widget.icon!,
      );
    }
    return const SizedBox.shrink();
  }

  MaterialStateProperty<Color?>? getOverlayColor() {
    if (widget.ripple == true) {
      return MaterialStatePropertyAll(
          isPrimaryButton() ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2));
    }
    return MaterialStateProperty.all(Colors.transparent);
  }

  bool isPrimaryButton() {
    return widget.type == ButtonUiType.primary || widget.type == null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStatePropertyAll(widget.elevation),
          overlayColor: getOverlayColor(),
          backgroundColor: widget.onPressed != null
              ? MaterialStatePropertyAll(
                  widget.backgroundColor ?? (isPrimaryButton() ? ColorKeys.skyBlue : Colors.white),
                )
              : null,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              side: BorderSide(color: widget.borderColor), // Set the border stroke color here
            ),
          ),
        ),
        onPressed: widget.onPressed,
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildIcon(),
              if (widget.leading != null) ...[
                widget.leading!,
                SizedBox(
                  width: widget.gap ?? 4,
                ),
              ],
              widget.isFittedLabel
                  ? Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.label,
                          textAlign: TextAlign.center,
                          style: widget.textStyle ??
                              TextStyle(
                                color: isPressed
                                    ? ColorKeys.skyBlue
                                    : widget.type == ButtonUiType.primary || widget.type == null
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                              ),
                        ),
                      ),
                    )
                  : Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.label,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: widget.textStyle ??
                              TextStyle(
                                color: widget.type == ButtonUiType.primary || widget.type == null
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                              ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
