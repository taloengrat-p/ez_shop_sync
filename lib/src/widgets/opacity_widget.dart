import 'package:flutter/material.dart';

class OpacityWidget extends StatelessWidget {
  final bool disabled;
  final Widget child;

  const OpacityWidget({
    Key? key,
    this.disabled = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.25 : 1,
      child: IgnorePointer(
        ignoring: disabled,
        child: child,
      ),
    );
  }
}
