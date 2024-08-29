import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:flutter/material.dart';

class ContainerPreviewWidget extends StatelessWidget {
  final Widget? child;
  final double? height;
  const ContainerPreviewWidget({
    super.key,
    this.child,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 140,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(LocaleKeys.preview.tr()),
          ),
          Center(
            child: child,
          )
        ],
      ),
    );
  }
}
