import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_type.dart';
import 'package:ez_shop_sync/src/widgets/container/container_price_category_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/row_gap_widget.dart';
import 'package:flutter/material.dart';

class PriceGroupSelectWidget extends StatelessWidget {
  final List<ProductType> items;
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
                onChange?.call(e.id);
              },
              child: ContainerPriceCategoryWidget(
                label: e.name,
                isSelect: itemSelected == e.id,
              ),
            ),
          )
          .toList(),
    );
  }
}
