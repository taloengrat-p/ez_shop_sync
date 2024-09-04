import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleDeleteButton extends ContainerCircleWidget {
  const CircleDeleteButton({
    super.key,
    super.onPressed,
  }) : super(
          color: Colors.red,
          child: const Icon(CupertinoIcons.delete),
        );
}
