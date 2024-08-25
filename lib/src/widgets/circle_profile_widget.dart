import 'package:ez_shop_sync/res/colors.dart';
import 'package:flutter/material.dart';

class CircleProfileWidget extends StatelessWidget {
  final String? title;
  const CircleProfileWidget({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: ColorKeys.white,
      child: Text(
        title ?? '',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
