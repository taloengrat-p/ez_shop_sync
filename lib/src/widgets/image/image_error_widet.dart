import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/drawables.dart';
import 'package:flutter/material.dart';

class ImageErrorWidet extends StatelessWidget {
  const ImageErrorWidet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(child: Image.asset(Drawables.emptyImage)),
        Container(
          alignment: Alignment.center,
          decoration: containerDecoration(Colors.grey.withOpacity(0.4)),
          child: Icon(Icons.error_outline_rounded, color: Colors.red.shade400, size: 120),
        ),
      ],
    );
  }

  BoxDecoration containerDecoration(Color color) =>
      BoxDecoration(borderRadius: BorderRadius.circular(DimensionsKeys.radius), color: color);
}
