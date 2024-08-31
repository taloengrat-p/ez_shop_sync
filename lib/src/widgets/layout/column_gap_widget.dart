import 'package:flutter/cupertino.dart';

class ColumnGapWidget extends StatelessWidget {
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final List<Widget> children;
  final double gap;
  const ColumnGapWidget({
    super.key,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    required this.children,
    this.gap = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: children
          .asMap()
          .map((k, e) {
            return MapEntry(
              k,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  e,
                  if (k != children.length - 1 && children.length != 1)
                    SizedBox(
                      height: gap,
                    ),
                ],
              ),
            );
          })
          .values
          .toList(),
    );
  }
}
