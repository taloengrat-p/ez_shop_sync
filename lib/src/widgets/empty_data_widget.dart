import 'package:ez_shop_sync/res/image_constance.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:flutter/material.dart';

class EmptyDataWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final String? message;

  const EmptyDataWidget({
    Key? key,
    this.height,
    this.width,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          Drawables.emptyData,
          height: height,
          width: width,
        ),
        if (message.isNotNull) Text(message!),
      ],
    );
  }
}
