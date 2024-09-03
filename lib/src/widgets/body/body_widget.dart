import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:flutter/material.dart';

class BodyWidget extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  final List<Widget>? actions;
  final Widget? header;

  const BodyWidget({
    super.key,
    required this.children,
    this.title,
    this.actions,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Column(
            children: [
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
              if (header != null) ...[
                const SizedBox(
                  height: 8,
                ),
                header!
              ],
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DimensionsKeys.pagePaddingHzt,
            ),
            child: Column(
              children: [...children],
            ),
          ),
        ),
        Container(
          height: DimensionsKeys.heightBts,
        ),
      ],
    );
  }
}
