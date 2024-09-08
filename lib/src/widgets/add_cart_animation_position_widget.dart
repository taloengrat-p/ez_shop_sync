import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCartAnimationPositionWidget extends StatelessWidget {
  final bool isShow;
  final Duration duration;
  final Offset origin;
  const AddCartAnimationPositionWidget({
    super.key,
    this.isShow = false,
    this.duration = const Duration(microseconds: 700),
    this.origin = const Offset(0, 0),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: duration,
      top: isShow ? 35 : origin.dy,
      right: isShow ? 20 : (origin.dx - 100),
      child: isShow
          ? const Icon(
              CupertinoIcons.bag,
              color: Colors.black,
            )
          : Container(),
    );
  }
}
