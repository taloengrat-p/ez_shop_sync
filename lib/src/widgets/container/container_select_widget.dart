import 'package:flutter/material.dart';

class ContainerSelectWidget extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final GestureTapCallback? onTap;
  final Function()? onChange;
  final bool isSelect;
  const ContainerSelectWidget({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.onTap,
    this.onChange,
    required this.isSelect,
  });

  @override
  State<ContainerSelectWidget> createState() => _ContainerSelectWidgetState();
}

class _ContainerSelectWidgetState extends State<ContainerSelectWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChange?.call();
      },
      child: Container(
        padding: widget.padding,
        margin: widget.margin,
        child: Stack(
          children: [
            widget.child,
            if (widget.isSelect)
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.blue,
              )
          ],
        ),
      ),
    );
  }
}
