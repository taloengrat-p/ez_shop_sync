import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
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
  final Axis axis;
  final bool isLabelUpperCase;

  const ButtonWidget({
    super.key,
    this.isLabelUpperCase = true,
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
    this.axis = Axis.horizontal,
  });

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

  WidgetStateProperty<Color?>? getOverlayColor() {
    if (widget.ripple == true) {
      return WidgetStatePropertyAll(isPrimaryButton() ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2));
    }
    return WidgetStateProperty.all(Colors.transparent);
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
          elevation: WidgetStatePropertyAll(widget.elevation),
          overlayColor: getOverlayColor(),
          backgroundColor: getBackgroundColor(),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              side: BorderSide(color: widget.borderColor), // Set the border stroke color here
            ),
          ),
        ),
        onPressed: widget.disabled ? null : widget.onPressed,
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 8.0),
          child: widget.axis == Axis.horizontal
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...buildChildren(),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...buildChildren(),
                  ],
                ),
        ),
      ),
    );
  }

  List<Widget> buildChildren() {
    return [
      buildIcon(),
      if (widget.leading != null) ...[
        Theme(
            data: ThemeData(
              iconTheme: IconThemeData(color: getColor().getContrast()),
            ),
            child: widget.leading!),
        SizedBox(
          width: widget.gap ?? 4,
        ),
      ],
      widget.isFittedLabel
          ? Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.isLabelUpperCase ? widget.label : widget.label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: widget.textStyle ??
                      TextStyle(
                        color: getColor().getContrast(),
                      ),
                ),
              ),
            )
          : Text(
              widget.isLabelUpperCase ? widget.label : widget.label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: widget.textStyle ??
                  TextStyle(
                    color: getColor().getContrast(),
                  ),
            ),
    ];
  }

  WidgetStateProperty<Color>? getBackgroundColor() {
    return widget.disabled
        ? null
        : widget.onPressed != null
            ? WidgetStatePropertyAll(
                getColor(),
              )
            : null;
  }

  Color getColor() {
    return widget.backgroundColor ?? (isPrimaryButton() ? ColorKeys.primary : Colors.white);
  }
}

class WeirdBorder extends ShapeBorder {
  final double radius;
  final double pathWidth;

  const WeirdBorder({required this.radius, this.pathWidth = 1});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect, textDirection: textDirection!), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => _createPath(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => WeirdBorder(radius: radius);

  Path _createPath(Rect rect) {
    final innerRadius = radius + pathWidth;
    final innerRect =
        Rect.fromLTRB(rect.left + pathWidth, rect.top + pathWidth, rect.right - pathWidth, rect.bottom - pathWidth);

    final outer = Path.combine(PathOperation.difference, Path()..addRect(rect), _createBevels(rect, radius));
    final inner = Path.combine(PathOperation.difference, Path()..addRect(innerRect), _createBevels(rect, innerRadius));
    return Path.combine(PathOperation.difference, outer, inner);
  }

  Path _createBevels(Rect rect, double radius) {
    return Path()
      ..addOval(Rect.fromCircle(center: Offset(rect.left, rect.top), radius: radius))
      ..addOval(Rect.fromCircle(center: Offset(rect.left + rect.width, rect.top), radius: radius))
      ..addOval(Rect.fromCircle(center: Offset(rect.left, rect.top + rect.height), radius: radius))
      ..addOval(Rect.fromCircle(center: Offset(rect.left + rect.width, rect.top + rect.height), radius: radius));
  }
}
