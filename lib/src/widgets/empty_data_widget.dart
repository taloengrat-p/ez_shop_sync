import 'package:ez_shop_sync/res/drawables.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:flutter/material.dart';

class EmptyDataWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final String? message;

  const EmptyDataWidget({
    super.key,
    this.height,
    this.width,
    this.message,
  });

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
        if (message.isNotNull)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              message!,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
