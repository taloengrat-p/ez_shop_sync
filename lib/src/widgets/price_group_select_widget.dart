import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/widgets/layout/row_gap_widget.dart';
import 'package:flutter/material.dart';

class PriceGroupSelectWidget extends StatelessWidget {
  final List<String> items;
  final String? itemSelected;
  final Function(String value)? onChange;
  final Color? color;

  const PriceGroupSelectWidget({
    super.key,
    required this.items,
    required this.itemSelected,
    this.onChange,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RowGapWidget(
      gap: 12,
      children: items
          .map(
            (e) => GestureDetector(
              onTap: () {
                onChange?.call(e);
              },
              child: Container(
                padding: const EdgeInsetsDirectional.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color: itemSelected == e ? color ?? Colors.amber : null,
                  border: Border.all(color: itemSelected == e ? Colors.transparent : color ?? Colors.amber),
                  borderRadius: BorderRadius.circular(DimensionsKeys.radius / 2),
                ),
                child: Text(
                  e.toString(),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
