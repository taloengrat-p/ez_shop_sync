import 'package:ez_shop_sync/res/drawables.dart';
import 'package:flutter/material.dart';

class EmptyImage extends StatelessWidget {
  const EmptyImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.all(16), child: Image.asset(Drawables.emptyImage));
  }
}
