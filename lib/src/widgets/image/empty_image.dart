import 'package:ez_shop_sync/res/drawables.dart';
import 'package:flutter/material.dart';

class EmptyImage extends StatelessWidget {
  const EmptyImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(Drawables.emptyImage);
  }
}
