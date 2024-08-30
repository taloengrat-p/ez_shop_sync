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
  final double? innerRadius;
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
  final bool disabled;
  const ButtonWidget({
    Key? key,
    this.type,
    this.innerRadius,
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
    this.disabled = false,
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
      return MaterialStatePropertyAll(isPrimaryButton()
          ? Colors.white.withOpacity(0.2)
          : Colors.black.withOpacity(0.2));
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
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStatePropertyAll(widget.elevation),
          overlayColor: getOverlayColor(),
          backgroundColor: widget.disabled
              ? null
              : widget.onPressed != null
                  ? MaterialStatePropertyAll(
                      // widget.backgroundColor ??
                      widget.backgroundColor ??
                          (isPrimaryButton()
                              ? ColorKeys.primary
                              : Colors.white),
                    )
                  : null,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              side: BorderSide(
                  color:
                      widget.borderColor), // Set the border stroke color here
            ),
          ),
        ),
        onPressed: widget.disabled ? null : widget.onPressed,
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
                                color: widget.disabled
                                    ? Colors.grey
                                    : isPressed
                                        ? ColorKeys.secondary
                                        : widget.type == ButtonUiType.primary ||
                                                widget.type == null
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
                                color: widget.disabled
                                    ? Colors.grey
                                    : widget.type == ButtonUiType.primary ||
                                            widget.type == null
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

class WeirdBorder extends ShapeBorder {
  final double radius;
  final double pathWidth;

  WeirdBorder({required this.radius, this.pathWidth = 1});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect, textDirection: textDirection!), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      _createPath(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => WeirdBorder(radius: radius);

  Path _createPath(Rect rect) {
    final innerRadius = radius + pathWidth;
    final innerRect = Rect.fromLTRB(rect.left + pathWidth, rect.top + pathWidth,
        rect.right - pathWidth, rect.bottom - pathWidth);

    final outer = Path.combine(PathOperation.difference, Path()..addRect(rect),
        _createBevels(rect, radius));
    final inner = Path.combine(PathOperation.difference,
        Path()..addRect(innerRect), _createBevels(rect, innerRadius));
    return Path.combine(PathOperation.difference, outer, inner);
  }

  Path _createBevels(Rect rect, double radius) {
    return Path()
      ..addOval(
          Rect.fromCircle(center: Offset(rect.left, rect.top), radius: radius))
      ..addOval(Rect.fromCircle(
          center: Offset(rect.left + rect.width, rect.top), radius: radius))
      ..addOval(Rect.fromCircle(
          center: Offset(rect.left, rect.top + rect.height), radius: radius))
      ..addOval(Rect.fromCircle(
          center: Offset(rect.left + rect.width, rect.top + rect.height),
          radius: radius));
  }
}
