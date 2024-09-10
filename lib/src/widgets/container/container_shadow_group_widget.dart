import 'package:ez_shop_sync/src/widgets/container/container_shadow_widget.dart';
import 'package:flutter/material.dart';

class ContainerShadowGroupWidget extends StatelessWidget {
  final Color? color;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final String title;
  final List<Widget> children;
  const ContainerShadowGroupWidget({
    super.key,
    required this.title,
    this.color,
    this.borderRadius,
    this.margin,
    this.padding,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerShadowWidget(
      padding: padding,
      margin: margin,
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ],
      ),
    );
  }
}
