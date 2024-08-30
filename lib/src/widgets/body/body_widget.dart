import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:flutter/material.dart';

class BodyWidget extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  final List<Widget>? actions;
  const BodyWidget({
    super.key,
    required this.children,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DimensionsKeys.pagePaddingHzt,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Spacer(),
                ...actions?.toList() ?? []
              ],
            ),
          ),
        ...children,
        Container(
          height: DimensionsKeys.heightBts,
        ),
      ],
    );
  }
}
