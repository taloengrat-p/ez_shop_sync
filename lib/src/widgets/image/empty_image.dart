import 'package:ez_shop_sync/res/image_constance.dart';
import 'package:flutter/material.dart';

class EmptyImage extends StatelessWidget {
  const EmptyImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(Drawables.emptyImage);
  }
}
