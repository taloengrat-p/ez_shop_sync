import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContainerPriceCategoryWidget extends StatelessWidget {
  final String label;
  final Color? color;
  final bool isSelect;
  const ContainerPriceCategoryWidget({
    super.key,
    required this.label,
    this.color,
    required this.isSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: isSelect ? color ?? Colors.amber : null,
        border: Border.all(color: isSelect ? Colors.transparent : color ?? Colors.amber),
        borderRadius: BorderRadius.circular(DimensionsKeys.radius / 2),
      ),
      child: Text(
        label,
      ),
    );
  }
}
